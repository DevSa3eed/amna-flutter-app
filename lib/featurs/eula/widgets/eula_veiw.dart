import 'package:flutter/material.dart';

import '../../../constants/cached_constants/cached_constants.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../model/eula_model.dart';

Widget EulaVeiw({required EulaModel eulaM0del}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        eulaM0del.header,
        style: TextStyles.lightBlue20blod,
      ),
      Text(
        eulaM0del.description,
        style: TextStyles.lightBlue16blod,
      ),
    ],
  );
}

late List<EulaModel> selected;
List<EulaModel> arabicEula = [
  EulaModel(
      header: 'مقدمة',
      description:
          'تحكم اتفاقية ترخيص المستخدم النهائي ("EULA") هذه استخدامك لتطبيق Amna وموقع الويب والخدمات الطبية ذات الصلة (مجتمعةً، "الخدمات"). من خلال الوصول إلى الخدمات أو استخدامها، فإنك توافق على الالتزام بالشروط والأحكام الواردة في اتفاقية EULA هذه. إذا كنت لا توافق على هذه الشروط، فأنت غير مخول باستخدام الخدمات.'),
  EulaModel(
      header: 'منح الترخيص',
      description:
          'يمنحك Amna ترخيصًا محدودًا، غير حصري، غير قابل للتحويل، قابل للإلغاء للوصول إلى الخدمات واستخدامها للاستخدام الشخصي غير التجاري. لا يجوز لك:\n\nتعديل الخدمات أو تكييفها أو ترجمتها أو إنشاء أعمال مشتقة منها.\nالهندسة العكسية أو فك تجميع أو تفكيك الخدمات.\nتأجير أو تأجير أو إقراض أو ترخيص فرعي أو توزيع الخدمات.\nاستخدام الخدمات لأي غرض غير قانوني أو محظور.'),
  EulaModel(
      header: 'محتوى المستخدم',
      description:
          'قد تتمكن من إرسال محتوى إلى الخدمات، مثل التقارير الطبية أو المراجعات. من خلال إرسال المحتوى، فإنك تمنح Amna ترخيصًا عالميًا، خاليًا من حقوق الملكية، دائمًا، غير قابل للإلغاء، غير حصري لاستخدام المحتوى الخاص بك، وإعادة إنتاجه، وتعديله، وتكييفه، ونشره، وأداءه، وعرضه، وتوزيعه، وإنشاء أعمال مشتقة منه في ارتباط بالخدمات.'),
  EulaModel(
      header: 'الملكية الفكرية',
      description:
          'الخدمات وكل المحتوى الموجود فيها محمية بموجب قوانين حقوق النشر والعلامات التجارية وغيرها من قوانين الملكية الفكرية. لا يجوز لك استخدام أي علامات تجارية أو شعارات Amna دون الحصول على إذن كتابي مسبق.'),
  EulaModel(
      header: 'إخلاء مسؤولية الضمانات',
      description:
          'يتم توفير الخدمات "كما هي" دون أي ضمانات من أي نوع، سواء صريحة أو ضمنية، بما في ذلك على سبيل المثال لا الحصر ضمانات البيع والتناسب لغرض معين وعدم الانتهاك. لا يضمن Amna أن تكون الخدمات خالية من الأخطاء أو موثوقة أو متاحة باستمرار.'),
  EulaModel(
      header: 'تحديد المسؤولية',
      description:
          'في أي حال، لن يكون Amna مسؤولاً عن أي أضرار غير مباشرة أو عرضية أو خاصة أو تبعية أو نموذجية، بما في ذلك على سبيل المثال لا الحصر الأضرار الناجمة عن فقدان الأرباح أو السمعة الطيبة أو الاستخدام أو البيانات أو أي خسائر غير ملموسة أخرى (حتى إذا تم إبلاغ Amna بإمكانية حدوث مثل هذه الأضرار) ، الناشئة عن أو فيما يتعلق باستخدام الخدمات أو عدم القدرة على استخدامها.'),
  EulaModel(
      header: 'التعويض',
      description:
          'توافق على تعويض Amna وشركائها والدفاع عنها وإبراء ذمتهم من أي مطالبات أو التزامات أو أضرار أو أحكام أو جوائز أو تكاليف أو نفقات (بما في ذلك رسوم المحاماة المعقولة) الناشئة عن أو المتعلقة باستخدامك للخدمات أو انتهاكك لهذه الاتفاقية.'),
  EulaModel(
      header: 'الإنهاء',
      description:
          'يجوز لـ Amna إنهاء اتفاقية EULA هذه أو حق الوصول إلى الخدمات في أي وقت، لأي سبب، دون إشعار مسبق. عند الإنهاء، يجب عليك وقف كل استخدام للخدمات.'),
  EulaModel(
      header: 'القانون الحاكم',
      description: 'يخضع هذا الاتفاق إلى القوانين ويفسر وفقًا لها.'),
];

List<EulaModel> englishEula = [
  EulaModel(
    header: 'Introduction',
    description:
        'This End-User License Agreement ("EULA") governs your use of the Amna application, website, and related medical services (collectively, the "Services"). By accessing or using the Services, you agree to be bound by the terms and conditions of this EULA. If you do not agree to these terms, you are not authorized to use the Services.',
  ),
  EulaModel(
      header: 'License Grant',
      description:
          'Amna grants you a limited, non-exclusive, non-transferable, revocable license to access and use the Services for your personal, non-commercial use. You may not: \nModify, adapt, translate, or create derivative works of the Services.\n Reverse engineer, decompile, or disassemble the Services.\n Rent, lease, lend, sublicense, or distribute the Services.\n Use the Services for any unlawful or prohibited purpose.'),
  EulaModel(
      header: 'User Content',
      description:
          'You may be able to submit content to the Services, such as medical reports or reviews. By submitting content, you grant Amna a worldwide, royalty-free, perpetual, irrevocable, non-exclusive license to use, reproduce, modify, adapt, publish, perform, display, distribute, and create derivative works of your content in connection with the Services.'),
  EulaModel(
      header: 'Intellectual Property',
      description:
          'The Services and all content contained therein are protected by copyright, trademark, and other intellectual property laws. You may not use any Amna trademarks or logos without prior written permission.'),
  EulaModel(
      header: 'Disclaimer of Warranties',
      description:
          'THE SERVICES ARE PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. AMNA DOES NOT WARRANT THAT THE SERVICES WILL BE ERROR-FREE, RELIABLE, OR CONTINUOUSLY AVAILABLE.'),
  EulaModel(
      header: 'Limitation of Liability',
      description:
          'IN NO EVENT SHALL AMNA BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR EXEMPLARY DAMAGES, INCLUDING BUT NOT LIMITED TO DAMAGES FOR LOSS OF PROFITS, GOODWILL, USE, DATA, OR OTHER INTANGIBLE LOSSES (EVEN IF AMNA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES), ARISING OUT OF OR IN CONNECTION WITH THE USE OR INABILITY TO USE THE SERVICES.'),
  EulaModel(
      header: 'Indemnification',
      description:
          'You agree to indemnify, defend, and hold harmless Amna and its affiliates from and against any claims, liabilities, damages, judgments, awards, costs, and expenses (including reasonable attorneys \' fees) arising out of or related to your use of the Services or your violation of this EULA.'),
  EulaModel(
    header: 'Termination',
    description:
        'Amna may terminate this EULA or your access to the Services at any time, for any reason, without prior notice. Upon termination, you must cease all use of the Services.',
  ),
  EulaModel(
      header: 'Governing Law',
      description:
          'This EULA shall be governed by and construed in accordance with applicable laws.'),
];

class ALLEula extends StatefulWidget {
  const ALLEula({super.key});

  @override
  State<ALLEula> createState() => _ALLEulaState();
}

class _ALLEulaState extends State<ALLEula> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      if (lang!) {
        selected = arabicEula;
      } else {
        selected = englishEula;
      }
    });
    return Column(
      children: [
        for (int i = 0; i < selected.length; i++)
          EulaVeiw(eulaM0del: selected[i]),
      ],
    );
  }
}
