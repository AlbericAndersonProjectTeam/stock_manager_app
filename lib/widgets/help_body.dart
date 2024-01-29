import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';



class HelpScreen extends StatefulWidget{
  const HelpScreen({super.key});

  @override
  HelpScreenState createState() => HelpScreenState();

}

class Faq{
  String title;
  String body;
  bool isExpanded;
  Faq({required this.title,required this.body, this.isExpanded = false});
}


class HelpScreenState extends State<HelpScreen> {

  List<Faq> faqs = [];

  @override
  void initState() {
    super.initState();
    faqs = [
      Faq(title: 'Comment ajouter un produit ?', body: 'Appuyez sur le boutton ajouter(+) situé dans le coin inférieur droit de la partie produit. Il vous suffira alors de remplir le formulaire affiché pour enregistrer votre nouveau produit.\nTous les champs sont obligatoires mis à part la date de péremption.'),
      Faq(title: 'Comment remplir le champ seuil lors de l\'ajout d\'un produit ?', body: 'Le seuil est en unité de produit, le nombre minimal de produits qu\'un stock qui contiendrait ce produit doit comporter. Lorsque la quantité du produit dans un stock passe en dessous de ce nombre, il y a alors rupture du produit dans le stock concerné.\nNB: Vous pourrez toujours changer le seuil du produit au moment de l\'ajouter dans un stock, mais ceci constitue une valeur par défaut.'),
      Faq(title: 'Comment ajouter un stock ?', body: 'Appuyez sur le boutton ajouter(+) situé dans le coin inférieur droit de la partie stock. L\'ajout d\'un stock se déroule alors en deux (02) étapes : \n1.Dans la boîte de dialogue qui s\'affiche, renseignez le nom et la location du nouveau stock.\n2.Ajoutez ensuite en appuyant sur le boutton ajouter de la nouvelle page qui s\'affiche les lots constitutifs de votre nouveau stock puis enregistrez pour terminer.'),
      Faq(title: 'Comment ajouter un lot constitutif dans un stock ?', body: 'Un lot constitutif est un ensemble minimal de produits dans un stock et possédant un seuil.\nAprès avoir appuyé sur le boutton ajouter de la page lots du stock : \n1.Choisissez le produit qui constituera le lot. Le nouveau lot ainsi créé apparaîtra dans la liste des lots avec comme nombre de produits 0 et comme seuil le seuil donné au produit lors de son enregistrement.\n2.Important : Tapez double sur le nouveau lot pour changer la valeur 0 du nombre de produit du lot à celle que vous souhaiter avoir dans le stock. Vous pouvez aussi changer le seuil du produit dans ce lot (optionnel)'),
      Faq(title: 'Est-il conseillé de modifier les lots constitutifs d\'un stock directement dans la partie lot du stock ?', body: 'Oui, en cas d\'erreurs ou de modifications que vous ne souhaitez pas traçer. Mais pour des modifications dont vous souhaitez garder des traces, ce qui est plutôt, c\'est conseillé est de faire des transactions regroupant ces modifications.'),
      Faq(title: 'Comment faire une transaction dans un stock ?', body: 'Une transaction dans un stock est un mouvement de produits du stock : vente, achat, transfert dans un autre stock.\nRendez vous dans la partie transaction du stock et appuyez sur le boutton nouvelle : \n1.Choississez le type de transaction à faire.\n2.Remplissez le formulaire spécifique à chaque type de transaction.\n3.Ajoutez les lots concernés par la transaction(les calculs nécessaires soustraction ou ajout seront gérés par StockManager).'),
      Faq(title: 'Comment consulter les transactions d\'un stock ?', body: 'Rendez vous dans la partie transaction du stock en question. Tapez sur la catégorie de transaction à consluter. Vous verrez s\'afficher la liste des transctions (avec leurs détails) que vous pouvez filtrer par la date. Tapez ensuite sur une transaction pour afficher ses produits et leurs nombres.'),
      Faq(title: 'Comment ajouter un assistant ?', body: 'Seul le propriétaire peut ajouter un assitant. Si vous être le propriétaire alors appuyez sur le boutton ajouter(+) situé dans le coin inférieur droit de la partie assistant. Il vous suffira alors de remplir le formulaire affiché pour enregistrer votre nouvel assistant(employé ou administrateur).\nTous les champs sont obligatoires.'),
      Faq(title: 'Comment reçevoir les alertes de rupture de stock  ?', body: 'Cette option est confgurable dans les paramètres. Vous recevrez d\'abord des notifications dans StockManager et ensuite selon vos configurations, vous recevrez des alertes par mail ou directement dans la barre de notfifications de votre téléphone.'),
      Faq(title: 'Pourquoi n\'ai-je pas le droit de supprimer des produits ou stocks ?', body: 'Seuls le propriétaire et les assistants administrateurs peuvent supprimer des produits ou stocks.'),
    ];

  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(left: 20.0,top: 30.0,right: 20.0,bottom: 30.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Stock Manager',style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ', est l\'application de gestion de stock idéale pour toute entreprise souhaitant automatiser la gestion de ses stocks car elle se concentre non seulement sur l\'enregistrement de vos produits , l\'ajout des stocks proprement dits se basant sur vos produits enregistrés mais aussi sur la gestion d\'assistants vous permettant de gérer les données en toute cohésion avec vos personnes de confiances !')
                    ]
                  )
                ) ,),

                 ListTile(
            title: const Text(
              'Cliquez pour consulter la documentation complète.',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w400,decoration: TextDecoration.underline,decorationColor: primaryColor),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              final Uri url = Uri.parse('https://github.com/AlbericAndersonProjectTeam/stock_manager_app/blob/main/README.md');

                try {
                   await launchUrl(url);
                } catch (e) {
                    ToastMessage(message: "Action impossible sur cet appareil.").showToast();
                }
              
            },
          ),
              const SizedBox(height: 15.0,),

               ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  List<Faq> tempFaqs = [];
                  for (var i=0 ; i<faqs.length ;i++) {
                    if(i==panelIndex){
                      faqs[i].isExpanded = isExpanded;
                    }
                    tempFaqs.add(faqs[i]);
                  }
                  setState(() {
                    faqs = tempFaqs;
                  });
                },
                children: faqs.map<ExpansionPanel>((Faq faq) => 
                  ExpansionPanel(
                    headerBuilder: ((context, bool isExpanded) {
                    return Padding(padding: const EdgeInsets.all(10.0),child: Text(faq.title,style: const TextStyle(color: primaryColor,fontSize: 15.0, fontWeight: FontWeight.w500,),),);
                  }), 
                  body: ListTile(title:  Text(faq.body,style: const TextStyle(fontSize: 14.0),),),
                  isExpanded: faq.isExpanded,
                  )).toList(),
               ),
            
               const SizedBox(height: 40.0,),
              ],
            ),
    );
  }
  
}