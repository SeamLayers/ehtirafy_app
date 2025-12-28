import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/freelancer/domain/entities/freelancer_order_entity.dart';
import 'package:ehtirafy_app/features/freelancer/domain/repositories/freelancer_orders_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreelancerOrdersRepositoryImpl implements FreelancerOrdersRepository {
  final ContractRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  FreelancerOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<FreelancerOrderEntity>>> getOrders() async {
    try {
      // For freelancer/photographer, we use user_type=freelancer
      // Backend naming: freelancer = photographer who posts ads
      final contracts = await remoteDataSource.getContracts({
        'user_type': 'freelancer',
      });

      // Map ContractModel to FreelancerOrderEntity
      // FreelancerOrderEntity likely needs updates to match Contract fields if they differ significantly.
      // For now, mapping what we can.

      final orders = contracts.map((c) {
        FreelancerOrderStatus status;
        switch (c.contrPubStatus?.toLowerCase()) {
          case 'accepted':
          case 'inprogress':
          case 'approved': // Pending approval or Approved
            // If Approved, check customer status for Payment
            final custStatus = c.contrCustStatus?.toLowerCase();
            if (c.contrPubStatus?.toLowerCase() == 'approved') {
              if (custStatus == 'paid' ||
                  custStatus == 'inprocess' ||
                  custStatus == 'completed') {
                status = FreelancerOrderStatus.inProgress;
              } else {
                // Approved but not paid yet - strictly speaking this is 'Awaiting Payment'
                // For now, if we don't have a separate tab, map to Pending or InProgress?
                // User wants "active" after "paid".
                // So if NOT paid, it remains Pending (or a specialized status if we had one).
                // Logic: If user didn't reject, it's pending their action OR waiting for payment.
                // If status is 'Approved', the freelancer HAS accepted. So it shouldn't be in "New Requests" (Pending) which implies "Waiting for Freelancer Acceptance".
                // However, "Active" implies work can start.
                // Let's assume:
                // 1. Pending: Freelancer needs to Accept/Reject. (contr_pub_status is null or pending?)
                // 2. Active: Freelancer Accepted AND (Customer Paid OR trusting client).

                // If contr_pub_status is 'Approved', the freelancer HAS accepted.
                // So it typically shouldn't be in tab 0 (Requests).
                // Tab 0 filters for FreelancerOrderStatus.pending.

                // If I map 'Approved' to 'pending', it stays in Requests tab (as if I didn't accept it).
                // If I map 'Approved' to 'inProgress', it goes to Active tab.

                // User says: "after paid we should have it in the active contract tab".
                // This implies before paid (but accepted/approved), it might NOT be in active?
                // But it definitely shouldn't be in "Requests" (tab 0) asking for accept/reject again.

                // If I map to 'inProgress', it shows in Active.
                // If 'Paid' is required for 'Active', then what is it before Paid?
                // If I keep it as 'Pending', the UI will show Accept/Reject buttons again?

                // Let's look at UI. FreelancerOrderCard shows Accept/Reject if status is pending.
                // If we return 'pending', the user sees 'Accept/Reject'. But they ALREADY approved it.
                // This suggests we need a state for "Awaiting Payment" which is NOT "New Request".

                // However, sticking to the existing 3 tabs:
                // 1. Requests (New)
                // 2. Active (In Progress)
                // 3. Archived

                // If I approved it, it is no longer a "New Request".
                // It is technically "Active" (contract exists), just waiting for next step.
                // So 'Approved' should likely be 'inProgress' regarding the TABS.
                // But the user specifically said: "after paid we should have it in the active contract tab layout".
                // This implies: "Approved" (but not paid) -> ?? (Maybe still Requests?)

                // WAIT. If I set it to 'inProgress', it goes to tab 1.
                // If the user says "after paid... active", maybe they see it in "Requests" before paid?
                // If so, does the UI handle "Approved but not paid" in Requests tab?
                // The FreelancerOrderCard only has "Accept/Reject" for Pending.
                // It doesn't have "Waiting Payment".

                // CORRECT LOGIC:
                // If `contr_pub_status` is Approved, checking `contr_cust_status`.
                // If `Paid`, definitely `inProgress`.
                // If NOT `Paid`, it is still an active engagement, just early stage.
                // If we put it in Pending, the user sees "Accept/Reject" again, which is confusing/wrong.

                // Let's check the users constraint: "contract_status": "InProcess".
                // "contr_pub_status": "Approved", "contr_cust_status": "Paid".
                // This combination MUST be in Active.

                // So:
                status = FreelancerOrderStatus.inProgress;
              }
            } else {
              status = FreelancerOrderStatus.inProgress;
            }
            break;
          case 'completed':
            status = FreelancerOrderStatus.completed;
            break;
          case 'rejected':
          case 'cancelled':
            status = FreelancerOrderStatus.cancelled;
            break;
          default:
            // e.g. null, 'pending'
            status = FreelancerOrderStatus.pending;
        }

        return FreelancerOrderEntity(
          id: c.id.toString(),
          clientName: c.clientName ?? 'Unknown Client',
          serviceTitle: c.serviceTitle ?? 'Requested Service',
          status: status,
          price: double.tryParse(c.requestedAmount) ?? 0.0,
          location: 'Remote', // Placeholder as location isn't in contract yet
          eventDate: c.createdAt, // Using createdAt as event date for now
          createdAt: c.createdAt,
          clientImage: c.clientImage ?? '',
        );
      }).toList();

      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FreelancerOrderEntity>> acceptOrder(
    String orderId,
  ) async {
    try {
      final contract = await remoteDataSource.updateContract(orderId, {
        'contr_pub_status': 'Approved',
        'note_type': 'freelancer', // Required by API for freelancer actions
        '_method': 'put',
      });

      // Assume updated status is accepted/inProgress
      return Right(
        FreelancerOrderEntity(
          id: contract.id.toString(),
          clientName: contract.clientName ?? 'Unknown Client',
          serviceTitle: contract.serviceTitle ?? 'Requested Service',
          status: FreelancerOrderStatus.inProgress,
          price: double.tryParse(contract.requestedAmount) ?? 0.0,
          location: 'Remote',
          eventDate: contract.createdAt,
          createdAt: contract.createdAt,
          clientImage: contract.clientImage ?? '',
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectOrder(String orderId) async {
    try {
      await remoteDataSource.updateContract(orderId, {
        'contr_pub_status': 'Rejected',
        'note_type': 'freelancer', // Required by API for freelancer actions
        '_method': 'PUT',
      });
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeOrder(String orderId) async {
    try {
      await remoteDataSource.updateContract(orderId, {
        'contr_pub_status': 'Completed',
        'note_type': 'freelancer',
        '_method': 'PUT',
      });
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FreelancerOrderEntity>> getOrderDetails(
    String orderId,
  ) async {
    try {
      // Add user_type for freelancer + order ID filter
      final contracts = await remoteDataSource.getContracts({
        'user_type': 'freelancer',
        'id': orderId,
      });
      if (contracts.isNotEmpty) {
        final c = contracts.first;

        FreelancerOrderStatus status;
        switch (c.contrPubStatus?.toLowerCase()) {
          case 'accepted':
          case 'inprogress':
            status = FreelancerOrderStatus.inProgress;
            break;
          case 'completed':
            status = FreelancerOrderStatus.completed;
            break;
          case 'rejected':
          case 'cancelled':
            status = FreelancerOrderStatus.cancelled;
            break;
          default:
            status = FreelancerOrderStatus.pending;
        }

        return Right(
          FreelancerOrderEntity(
            id: c.id.toString(),
            clientName: c.clientName ?? 'Unknown Client',
            serviceTitle: c.serviceTitle ?? 'Requested Service',
            status: status,
            price: double.tryParse(c.requestedAmount) ?? 0.0,
            location: 'Remote',
            eventDate: c.createdAt,
            createdAt: c.createdAt,
            clientImage: c.clientImage ?? '',
          ),
        );
      }
      return const Left(ServerFailure('Order not found'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
