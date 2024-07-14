import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/pontos__de_interesse/escolherRating.dart';
import 'package:softshares_mobile/widgets/pontos__de_interesse/estrelas.dart';
import 'package:softshares_mobile/widgets/gerais/text_tools.dart';
import 'package:softshares_mobile/widgets/comentarios_section.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'dart:convert';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:softshares_mobile/widgets/gerais/galeria_widget.dart';

class ConsultPontoInteresseScreen extends StatefulWidget {
  const ConsultPontoInteresseScreen({
    super.key,
    required this.pontoInteresse,
  });

  final PontoInteresse pontoInteresse;

  @override
  State<ConsultPontoInteresseScreen> createState() {
    return _ConsultPontoInteresseScreenState();
  }
}

class _ConsultPontoInteresseScreenState
    extends State<ConsultPontoInteresseScreen> {
  PontoInteresse? pontoInteresse;
  List<Categoria> categorias = [];
  bool _isLoading = true;
  String? comentarioAtual;
  int rating = 0, avaliacaoId = 0;
  bool invalidRating = false;
  Utilizador? user;
  ApiService api = ApiService();
  List<Commentario> comentarios = [];
  final TextEditingController comentarioController = TextEditingController();
  bool tinhaAvaliado = false;

  Future<void> carregaDados() async {
    pontoInteresse = widget.pontoInteresse;
    final prefs = await SharedPreferences.getInstance();
    api.setAuthToken("tokenFixo");
    final idiomaId = prefs.getInt("idiomaId") ?? 1;

    user = Utilizador.fromJson(jsonDecode(prefs.getString('utilizadorObj')!));
    final ratingAntigo = await api.getRequest(
        'avaliacao/poi/${pontoInteresse!.pontoInteresseId}/utilizador/${user!.utilizadorId}');
    if (ratingAntigo['data'] != 0) {
      tinhaAvaliado = true;
      setState(() {
        rating = ratingAntigo['data']['avaliacao'] as int;
        avaliacaoId = ratingAntigo['data']['avaliacaoid'] as int;
      });
    } else {
      tinhaAvaliado = false;
    }
    print(ratingAntigo);
    CategoriaRepository categoriaRepository = CategoriaRepository();
    List<Categoria> categoriasdb =
        await categoriaRepository.fetchCategoriasDB(idiomaId);
    setState(() {
      categorias = categoriasdb;
      _isLoading = false;
    });
  }

  atualizarRating(int aval) {
    setState(() {
      rating = aval;
    });
  }

  void enviarAvaliacao() async {
    String message = '';
    setState(() {
      comentarioAtual = comentarioController.text;
    });
    if (comentarioAtual != "") {
      final Map<String, dynamic> commentJson = {
        "tipo": "POI",
        "idRegisto": pontoInteresse!.pontoInteresseId,
        "utilizadorid": user!.utilizadorId,
        "comentario": comentarioAtual,
        "comentarioPai ": null,
      };
      await api.postRequest("comentario/add", commentJson);

      message = AppLocalizations.of(context)!.comentarioAdd;
    }
    if (rating == 0) {
      setState(() {
        invalidRating == true;
      });
    } else {
      setState(() {
        invalidRating == false;
      });
      final Map<String, dynamic> criarAvaliacaoJson = {
        "tipo": "POI",
        "idRegisto": pontoInteresse!.pontoInteresseId,
        "utilizadorid": user!.utilizadorId,
        "avaliacao": rating,
      };
      final Map<String, dynamic> atualizarAvaliacaoJson = {
        "utilizadorid": user!.utilizadorId,
        "avaliacao": rating,
      };
      print(atualizarAvaliacaoJson);
      if (tinhaAvaliado) {
        message += AppLocalizations.of(context)!.avaliacaoAtualizada;
        await api.putRequest(
            "avaliacao/update/POI/${pontoInteresse!.pontoInteresseId}",
            atualizarAvaliacaoJson);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } else {
        message += AppLocalizations.of(context)!.avaliacaoCriada;
        await api.postRequest("avaliacao/add", criarAvaliacaoJson);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    carregaDados();
    pontoInteresse = widget.pontoInteresse;
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pontosInteresse,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // navega para o ecrã de edição do evento
              String partilha =
                  "${AppLocalizations.of(context)!.pontosInteresse}: ${pontoInteresse!.titulo} - ${pontoInteresse!.localizacao} ";
              Share.share(partilha);
            },
            icon: const Icon(FontAwesomeIcons.shareNodes),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNavigation(seleccao: 1),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : categorias.isEmpty
              ? Container(
                  height: altura * 0.8,
                  color: Colors.transparent,
                  child: Center(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.naoHaDados),
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  top: true,
                  bottom: true,
                  right: true,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: altura * 0.01,
                      left: largura * 0.01,
                      right: largura * 0.01,
                      bottom: altura * 0.01,
                    ),
                    height: altura * 0.9,
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).canvasColor,
                            ),
                          )
                        : SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: FadeInImage(
                                      fit: BoxFit.fill,
                                      height: altura * 0.2,
                                      width: double.infinity,
                                      placeholder: const AssetImage(
                                          "Images/Restaurante.jpg"),
                                      image: pontoInteresse!.imagens != null &&
                                              pontoInteresse!
                                                  .imagens!.isNotEmpty
                                          ? NetworkImage(
                                              pontoInteresse!.imagens![0])
                                          : const AssetImage(
                                                  "Images/Restaurante.jpg")
                                              as ImageProvider,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: altura * 0.2,
                                          width: double.infinity,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  Text(
                                    pontoInteresse!.titulo,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  EstrelasRating(
                                      rating: pontoInteresse!.avaliacao!),
                                  SizedBox(height: altura * 0.02),
                                  Row(
                                    children: [
                                      const Icon(
                                        FontAwesomeIcons.locationDot,
                                        color: Colors.red,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: largura * 0.02),
                                        child:
                                            Text(pontoInteresse!.localizacao),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  Center(
                                    child: SizedBox(
                                      height: altura * 0.25,
                                      width: largura * 0.85,
                                      child: GoogleMap(
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId("1"),
                                            position: LatLng(
                                              double.parse(
                                                  pontoInteresse!.latitude!),
                                              double.parse(
                                                  pontoInteresse!.longitude!),
                                            ),
                                          ),
                                        },
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                            double.parse(
                                                pontoInteresse!.latitude!),
                                            double.parse(
                                                pontoInteresse!.longitude!),
                                          ),
                                          zoom: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DividerWithText(
                                      text: AppLocalizations.of(context)!
                                          .descricao),
                                  Text(pontoInteresse!.descricao),
                                  DividerWithText(
                                      text: AppLocalizations.of(context)!
                                          .avaliar),
                                  TextFormField(
                                    controller: comentarioController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .deixaComentario,
                                      border:
                                          InputBorder.none, // Remove the border
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0), // Add padding
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RatingPicker(
                                            initialRating: rating,
                                            onRatingSelected: atualizarRating),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          enviarAvaliacao();
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .avaliar),
                                      ),
                                    ],
                                  ),
                                  DividerWithText(
                                      text: AppLocalizations.of(context)!
                                          .imageGallery),
                                  GaleriaWidget(
                                    urls: pontoInteresse!.imagens != null
                                        ? pontoInteresse!.imagens!
                                        : [],
                                  ),
                                  const Divider(
                                    color: Color.fromRGBO(29, 90, 161, 1),
                                  ),
                                  Text(AppLocalizations.of(context)!
                                      .outrosComentarios),
                                  SizedBox(
                                    height: altura * 0.5,
                                    child: CommentSection(
                                      tabela: "POI",
                                      idRegisto:
                                          pontoInteresse!.pontoInteresseId,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
    );
  }
}
