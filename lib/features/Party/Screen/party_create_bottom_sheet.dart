import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:expenseapp/features/Party/Cubits/Party/add_party_cubit.dart';
import 'package:expenseapp/features/Party/Cubits/Party/update_party_cubit.dart';

import 'package:flutter/material.dart';

void showCreatePartySheet(BuildContext context, {bool isEdit = false, Party? party}) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'Create Party',
    barrierColor: Colors.black.withValues(alpha: .35),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: _PartyCreateWidget(isEdit: isEdit, party: party),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(animation.value),
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

class _PartyCreateWidget extends StatefulWidget {
  const _PartyCreateWidget({required this.isEdit, super.key, this.party});
  final bool isEdit;
  final Party? party;

  @override
  State<_PartyCreateWidget> createState() => _PartyCreateWidgetState();
}

class _PartyCreateWidgetState extends State<_PartyCreateWidget> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  String? selectedAccountId;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.isEdit ? widget.party!.name! : '';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.read<AddPartyCubit>().state is! AddPartyLoading && context.read<UpdatePartyCubit>().state is! UpdatePartyLoading) {
          Navigator.of(context).pop();
          return;
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: isTablet ? MediaQuery.of(context).size.width * 0.45 : MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsetsDirectional.all(20),
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(16)),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextView(text: widget.isEdit ? context.tr('updateParty') : context.tr('addPartyKey'), fontSize: 20.sp(context), fontWeight: FontWeight.bold, color: colorScheme.onSurface),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,

                  decoration: InputDecoration(
                    hintText: context.tr('partyNameKey'),
                    hintStyle: TextStyle(fontSize: 16.sp(context)),
                    prefixIcon: const Icon(Icons.people),
                    border: const OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: context.height * 0.01),

                const SizedBox(height: 24),

                MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => AddPartyCubit()),
                    BlocProvider(create: (context) => UpdatePartyCubit()),
                  ],

                  child: BlocConsumer<UpdatePartyCubit, UpdatePartyState>(
                    listener: (context, updateState) {
                      if (updateState is UpdatePartySuccess) {
                        context.read<GetPartyCubit>().updatePartyLocally(updateState.party);
                        log('updateState.party.transaction ${updateState.party.toJson()}');
                        UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('partyUpdateSuccess'));
                        Navigator.pop(context);
                      }

                      if (updateState is UpdatePartyFailure) {
                        Navigator.pop(context);

                        UiUtils.showCustomSnackBar(context: context, errorMessage: updateState.message);
                      }
                    },
                    builder: (context, updateState) {
                      return BlocConsumer<AddPartyCubit, AddPartyState>(
                        listener: (context, addState) {
                          if (addState is AddPartySuccess) {
                            Navigator.pop(context);
                            UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('partyAddSuccess'));
                            context.read<GetPartyCubit>().addPartyLocally(addState.party);
                          }
                          if (addState is AddPartyFailure) {
                            UiUtils.showCustomSnackBar(context: context, errorMessage: addState.message);
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, addState) {
                          return Row(
                            children: [
                              Expanded(
                                child: CustomRoundedButton(
                                  onPressed: () {
                                    // to close the kyeboard
                                    final currentFocus = FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    final partyId = 'PT'.withDateTimeMillisRandom();
                                    if (_nameController.text.isEmpty) {
                                      UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('partyNameKyReq'));
                                    } else {
                                      if (widget.isEdit) {
                                        context.read<UpdatePartyCubit>().updateParty(
                                          widget.party!,
                                          id: widget.party!.id,
                                          name: _nameController.text,
                                          createdAt: widget.party!.createdAt,
                                          updatedAt: DateTime.now().toString(),
                                          transaction: widget.party!.transaction,
                                        );
                                      } else {
                                        context.read<AddPartyCubit>().addParty(
                                          Party(
                                            id: partyId,
                                            name: _nameController.text,
                                            createdAt: DateTime.now().toString(),
                                            updatedAt: DateTime.now().toString(),
                                            transaction: [],
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  width: 1,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  text: widget.isEdit ? context.tr('update') : context.tr('addKey'),
                                  borderRadius: BorderRadius.circular(8),
                                  height: context.isTablet
                                      ? context.height * 0.035
                                      : context.isDesktop
                                      ? context.height * 0.034
                                      : context.height * 0.05,
                                  textStyle: TextStyle(fontSize: 16.sp(context)),
                                  isLoading: widget.isEdit ? updateState is UpdatePartyLoading : addState is AddPartyLoading,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: CustomRoundedButton(
                                  onPressed: () {
                                    if (widget.isEdit) {
                                      if (updateState is! UpdatePartyLoading) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      if (addState is! AddPartyLoading) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  width: 1,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  text: context.tr('cancelKey'),
                                  borderRadius: BorderRadius.circular(8),
                                  height: context.isTablet
                                      ? context.height * 0.035
                                      : context.isDesktop
                                      ? context.height * 0.034
                                      : context.height * 0.05,
                                  textStyle: TextStyle(fontSize: 16.sp(context)),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
