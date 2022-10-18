import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:thunderapp/components/buttons/custom_text_button.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/forms/custom_text_form_field.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/add%20new%20ramp/add_new_ramp_controller.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/shared/components/dialogs/default_alert_dialog.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/db/firestore_db_manager.dart';

class AddNewRampScreen extends StatefulWidget {
  const AddNewRampScreen({super.key});

  @override
  State<AddNewRampScreen> createState() =>
      _AddNewRampScreenState();
}

class _AddNewRampScreenState
    extends State<AddNewRampScreen> {
  RampType type = RampType.median;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => AddNewRampController(),
      builder: (context, child) =>
          Consumer<AddNewRampController>(
        builder: (context, controller, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Adicionar nova rampa'),
            backgroundColor: Colors.orange,
            centerTitle: true,
            elevation: 2,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: size.height * 0.9,
              padding:
                  const EdgeInsets.all(kDefaultPadding),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '1 - Tire uma foto da rampa',
                        style: kCaption2,
                      ),
                      controller.pickedImage == null
                          ? Center(
                              child: TextButton.icon(
                                icon:
                                    Icon(Icons.camera_alt),
                                label: Text(
                                  'Tirar foto',
                                ),
                                onPressed: () {
                                  controller.pickImage();
                                },
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(
                                        16),
                                child: Image.file(
                                    width: size.width * 0.2,
                                    File(context
                                        .watch<
                                            AddNewRampController>()
                                        .pickedImage!
                                        .path)),
                              ),
                            ),
                      Text(
                        '2 - Forneça informações importantes',
                        style: kCaption2,
                      ),
                      VerticalSpacerBox(
                          size: SpacerSize.large),
                      Form(
                          child: Column(
                        children: <Widget>[
                          CustomTextFormField(
                            controller: controller
                                .referenceController,
                            label: 'Referência',
                          ),
                          VerticalSpacerBox(
                              size: SpacerSize.small),
                          CustomTextFormField(
                            controller: controller
                                .descriptionController,
                            label:
                                'Descrição ou comentário',
                          ),
                        ],
                      )),
                      VerticalSpacerBox(
                          size: SpacerSize.medium),
                      Text(
                        '3 - Como você julga a qualidade da rampa?',
                        style: kCaption2,
                      ),
                      VerticalSpacerBox(
                          size: SpacerSize.medium),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: [
                              Radio(
                                  value: RampType.good,
                                  groupValue:
                                      controller.type,
                                  onChanged:
                                      (RampType? value) {
                                    setState(() {
                                      controller.type =
                                          value!;
                                    });
                                  }),
                              Text(
                                'Boa',
                                style: kCaption1.copyWith(
                                    color: Colors.green),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Radio(
                                  value: RampType.median,
                                  groupValue:
                                      controller.type,
                                  onChanged:
                                      (RampType? value) {
                                    setState(() {
                                      controller.type =
                                          value!;
                                    });
                                  }),
                              Text(
                                'Média',
                                style: kCaption1.copyWith(
                                    color: Colors.orange),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Radio(
                                  value: RampType.bad,
                                  groupValue:
                                      controller.type,
                                  onChanged:
                                      (RampType? value) {
                                    setState(() {
                                      controller.type =
                                          value!;
                                    });
                                  }),
                              Text(
                                'Ruim',
                                style: kCaption1.copyWith(
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                      VerticalSpacerBox(
                          size: SpacerSize.large),
                      Text(
                        '4 - Nos dê acesso à sua localização',
                        style: kCaption2,
                      ),
                      Center(
                        child: TextButton.icon(
                            onPressed: () {
                              controller.getLocation();
                            },
                            icon: Icon(Icons.location_pin),
                            label:
                                Text('Pegar Localização')),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: controller.latitude == 0
                        ? Text(
                            'Precisamos da sua localização antes de prosseguir')
                        : PrimaryButton(
                            text: 'Concluir',
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DefaultAlertDialog(
                                        title:
                                            'Concluir inserção de rampa?',
                                        body:
                                            'Ao confirmar, você subirá estas informações',
                                        cancelText:
                                            'Cancelar',
                                        onConfirm: () {
                                          showDialog(
                                              context:
                                                  context,
                                              builder:
                                                  (context) {
                                                return const SimpleDialog(
                                                  children: [
                                                    Center(
                                                      child:
                                                          Text('Carregando'),
                                                    )
                                                  ],
                                                  title: Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                );
                                              });

                                          controller
                                              .finishCreation();
                                        },
                                        confirmText:
                                            'Enviar');
                                  });
                            }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
