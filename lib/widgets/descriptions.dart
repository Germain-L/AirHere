import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// example function that was provided with the package,
// changed slightly to adopt the link as argument
// https://pub.dev/packages/url_launcher
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Descriptions extends StatefulWidget {

  @override
  _DescriptionsState createState() => _DescriptionsState();
}

class _DescriptionsState extends State<Descriptions> {

  // this widget is re used to create the same card for each pollutant,
  // arguments are added to create it,
  Widget descContainer(String name, String descriptions, String link) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      // GestureDetector is used to detect when the user presses on them
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () => _launchURL(link),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            //RichText is used to use different styles of text within a paragraph
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  //name variable will be displayed in bold (FontWeight.w600) and with a size of 20
                  TextSpan(text: "$name: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),

                  //while in the same paragraph the description will be of size 17 and normal weight
                  TextSpan(text: descriptions, style: TextStyle(fontSize: 17))
                ],
              )
            )
          ),
        ),
      ),
    );
  }

 
 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5, top: 5),
            child: Text("Main pollutants:", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
          ),
          descContainer(
            'PM₂.₅',
            "refers to atmospheric particulate matter (PM) that have a diameter of less than 2.5 micrometers,"+
            "which is about 3% the diameter of a human hair. particles in this category are so small that they "+
            "can only be detected with an electron microscope.",
            "http://www.npi.gov.au/resource/particulate-matter-pm10-and-pm25"
          ),
          descContainer(
            "PM₁₀",
            "2.5 to 10 micrometers in diameter. Sources include crushing or grinding operations and dust stirred up by vehicles on roads.",
            "http://www.npi.gov.au/resource/particulate-matter-pm10-and-pm25"
          ),
          descContainer(
            "NO₂",
            "Nitrogen dioxide is a nasty-smelling gas. "+
            "Some nitrogen dioxide is formed naturally in the atmosphere by lightning and some is produced by plants, soil and water. "+
            "However, only about 1% of the total amount of nitrogen dioxide found in our cities' air is formed this way.\n"+
            "Nitrogen dioxide is an important air pollutant because it contributes to the formation of photochemical smog, which can have significant impacts on human health.",
            "https://www.environment.gov.au/protection/publications/factsheet-nitrogen-dioxide-no2"
          ),
          descContainer(
            "o₃",
            "Ground-level ozone (O3), unlike other pollutants mentioned, is not emitted directly into the atmosphere, "+
            "but is a secondary pollutant produced by reaction between nitrogen dioxide (NO2), hydrocarbons and sunlight. "+
            "Ozone levels are not as high in urban areas (where high levels of NO are emitted from vehicles) as in rural areas. "+
            "Sunlight provides the energy to initiate ozone formation; consequently, high levels of ozone are generally observed during hot, "+
            "still sunny, summertime weather.",
            "https://www.health.nsw.gov.au/environment/air/Pages/ozone.aspx"
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
            child: Text("Other pollutants", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold,),),
          ),
          descContainer(
            "SO₂",
            "Sulphur dioxide is highly reactive gas with a pungent irritating smell. It is formed by fossil fuel combustion at power plants and other industrial facilities",
            "https://www.health.nsw.gov.au/environment/air/Pages/sulphur-dioxide.aspx"
          ),
          descContainer(
            "Lead",
            "Lead is a heavy metal which exists naturally in the earth's crust. "+
            "It is found throughout the environment in water and air. Natural concentrations of lead are low but exploitation "+
            "of lead as a useful metal has increased the level of exposure to this contaminant. In those countries which still mainly "+
            "use leaded petrol, most of the lead in the air comes from petrol-fuelled vehicles. While the dangers of exposure to high levels of lead are well known, there is very serious concern that low levels of lead may affect the mental development of children",
            "https://www.epa.gov/lead-air-pollution/basic-information-about-lead-air-pollution"
          ),
          descContainer(
            "Radon",
            "In specific geographical areas, and in buildings which have not been designed to be radon-proof, "+
            "concentrations of radon gas may reach levels that cause lung cancer. The increased risk of cancer from radon exposure "+
            "is strongly enhanced for smokers, and several thousands of extra cancers in Europe can be attributable to radon in regions of high emission",
            "https://courses.lumenlearning.com/introchem/chapter/indoor-pollution-radon/",
          )
        ],
      ),
    );
  }
}
