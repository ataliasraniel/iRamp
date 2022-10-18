import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:thunderapp/components/buttons/primary_button.dart';
import 'package:thunderapp/components/utils/vertical_spacer_box.dart';
import 'package:thunderapp/screens/screens_index.dart';
import 'package:thunderapp/shared/components/util/svg_pic_renderer.dart';
import 'package:thunderapp/shared/constants/app_enums.dart';
import 'package:thunderapp/shared/constants/app_number_constants.dart';
import 'package:thunderapp/shared/constants/style_constants.dart';
import 'package:thunderapp/shared/core/assets_index.dart';
import 'package:thunderapp/shared/core/navigator.dart';

class FinishAdditionScreen extends StatelessWidget {
  const FinishAdditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: <Widget>[
            const Spacer(),
            Text(
              'Sua contribuição foi enviada! 🥳',
              style: kTitle2,
            ),
            VerticalSpacerBox(size: SpacerSize.huge),
            SvgPicRenderer(
                filePath: Assets.finish,
                width: size.width * 0.5),
            VerticalSpacerBox(size: SpacerSize.huge),
            Text(
              'Obrigado por contribuir e tornar a cidade um pouco mais acessível a tod@s',
              textAlign: TextAlign.center,
            ),
            Spacer(),
            PrimaryButton(
                text: 'Voltar para o início',
                onPressed: () {
                  int count = 0;
                  navigatorKey.currentState!
                      .popUntil((route) => count++ == 3);
                })
          ],
        ),
      ),
    );
  }
}
