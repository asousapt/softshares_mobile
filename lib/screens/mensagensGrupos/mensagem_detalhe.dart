import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/mensagem_repository.dart';
import 'package:softshares_mobile/Repositories/utilizador_repository.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/mensagem.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/generic/galeria_fotos.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/info_grupo.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/info_utilizador.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MensagemDetalheScreen extends StatefulWidget {
  const MensagemDetalheScreen({
    super.key,
    required this.mensagemId,
    required this.nome,
    required this.imagemUrl,
    required this.msgGrupo,
    this.grupoId,
    this.utilizadorId,
  });

  final int mensagemId;
  final String nome;
  final String imagemUrl;
  final bool msgGrupo;
  final int? grupoId;
  final int? utilizadorId;

  @override
  State<StatefulWidget> createState() {
    return _MensagemDetalheScreenState();
  }
}

class _MensagemDetalheScreenState extends State<MensagemDetalheScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late int utilizadorId;
  late int grupoId;
  List<Mensagem> mensagens = [];
  bool _isLoading = false;
  List<XFile> _selectedImages = [];
  int mensagemId = 0;
  int omeuUserId = 0;

  // carrega mensagens da base de dados
  // carrega mensagens da base de dados
  Future<void> actualizaDados() async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    setState(() {
      omeuUserId = utilizador.utilizadorId;
    });

    // Check if mensagemId is not 0 and update state
    if (widget.mensagemId != 0) {
      setState(() {
        mensagemId = widget.mensagemId;
      });
    }
    print("o meu user id = $omeuUserId");
    print("widget util = ${widget.utilizadorId}");
    // Ensure utilizadorId and grupoId are not null
    if (widget.utilizadorId == null) {
      throw Exception("Utilizador ID is null");
    }
    if (widget.msgGrupo && widget.grupoId == null) {
      throw Exception("Grupo ID is null");
    }

    setState(() {
      utilizadorId = widget.utilizadorId!;
      grupoId = widget.grupoId ?? 0;
    });

    print("mensagemId: $mensagemId");
    if (mensagemId != 0) {
      setState(() {
        _isLoading = true;
      });
      MensagemRepository mensagemRepository = MensagemRepository();
      List<Mensagem> mensagensL = [];

      if (!widget.msgGrupo) {
        mensagensL = await mensagemRepository.getConversa(mensagemId);
      } else {
        mensagensL = await mensagemRepository.getConversaGr(mensagemId);
      }

      setState(() {
        mensagens = mensagensL;
        _isLoading = false;
      });

      // Scroll to the last message
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  void _onImagesPicked(List<XFile> images) {
    setState(() {
      _selectedImages = images;
    });
  }

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          top: true,
          bottom: true,
          child: Container(
            padding:
                EdgeInsets.only(right: largura * 0.02, left: largura * 0.02),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                SizedBox(width: largura * 0.02),
                InkWell(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.imagemUrl),
                      maxRadius: 20,
                    ),
                    onTap: () {
                      if (widget.msgGrupo) {
                        // Navegar para a página de informações do grupo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return GrupoInfoScreen(
                                grupoId: widget.grupoId!,
                              );
                            },
                          ),
                        );
                      } else {
                        // Navegar para a página de informações do utilizador
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UtilizadorInfoScreen(
                                utilizadorId: widget.utilizadorId!,
                                mostraGaleria: true,
                              );
                            },
                          ),
                        );
                      }
                    }),
                SizedBox(width: largura * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.nome,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: altura * 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).canvasColor,
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: mensagens.length + 1,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: altura * 0.02, bottom: altura * 0.02),
                  itemBuilder: (context, index) {
                    if (index == mensagens.length) {
                      return SizedBox(height: altura * 0.1);
                    }

                    bool isSender =
                        mensagens[index].remetente!.utilizadorId == omeuUserId;
                    return Container(
                      padding: EdgeInsets.only(
                          left: largura * 0.02,
                          right: largura * 0.02,
                          top: altura * 0.02,
                          bottom: altura * 0.02),
                      child: Column(
                        crossAxisAlignment: isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (widget.msgGrupo && !isSender) ...[
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      mensagens[index].remetente!.fotoUrl!),
                                  maxRadius: 12,
                                ),
                                SizedBox(width: largura * 0.02),
                                Text(
                                  mensagens[index].remetente!.getNomeCompleto(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: altura * 0.02),
                          ],
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isSender
                                  ? Theme.of(context)
                                      .secondaryHeaderColor
                                      .withOpacity(0.8)
                                  : Theme.of(context).canvasColor,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: largura * 0.02,
                                vertical: altura * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mensagens[index].mensagemTexto,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                // Mostrar imagens se existirem
                                if (mensagens[index].anexos!.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      // Navegar para a galeria de fotos
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoGalleryScreen(
                                            imageUrls: mensagens[index].anexos!,
                                            initialIndex: 0,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(top: altura * 0.02),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: largura * 0.02,
                                          mainAxisSpacing: altura * 0.02,
                                        ),
                                        itemCount:
                                            mensagens[index].anexos!.length > 4
                                                ? 4
                                                : mensagens[index]
                                                    .anexos!
                                                    .length,
                                        itemBuilder: (context, imgIndex) {
                                          if (imgIndex == 3 &&
                                              mensagens[index].anexos!.length >
                                                  4) {
                                            return Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                Image.network(
                                                  mensagens[index]
                                                      .anexos![imgIndex],
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  color: Colors.black54,
                                                  child: Center(
                                                    child: Text(
                                                      '+${mensagens[index].anexos!.length - 4}',
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .canvasColor,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return Image.network(
                                            mensagens[index].anexos![imgIndex],
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: altura * 0.01),
                          Text(
                            dataFormatadaMsg(mensagens[index].dataEnvio!, "pt"),
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).canvasColor),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(
                  left: largura * 0.02,
                  bottom: altura * 0.02,
                  top: altura * 0.02),
              height: altura * 0.1,
              width: double.infinity,
              color: Theme.of(context).canvasColor,
              child: Row(
                children: <Widget>[
                  /*FotoPicker(
                    pickedImages: _selectedImages,
                    onImagesPicked: _onImagesPicked,
                  ), */
                  SizedBox(width: largura * 0.02),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.writeMessage,
                          hintStyle: const TextStyle(color: Colors.black),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(width: largura * 0.02),
                  Container(
                    height: altura * 0.06,
                    width: largura * 0.12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        // Envio de mensagem
                        if (_messageController.text.trim().isNotEmpty ||
                            _selectedImages.isNotEmpty) {
                          setState(() {
                            _isLoading = true;
                          });
                          UtilizadorRepository utilizadorRepository =
                              UtilizadorRepository();
                          Utilizador? utilizadorEnvio;
                          if (widget.msgGrupo == false && mensagens.isEmpty) {
                            utilizadorEnvio = await utilizadorRepository
                                .getUtilizador(utilizadorId.toString());
                          } else if (mensagens.isNotEmpty &&
                              omeuUserId != utilizadorId) {
                            utilizadorEnvio = await utilizadorRepository
                                .getUtilizador(utilizadorId.toString());
                          } else {
                            utilizadorEnvio = await utilizadorRepository
                                .getUtilizador(omeuUserId.toString());
                          }

                          Mensagem msg = Mensagem(
                            mensagemTexto: _messageController.text.trim(),
                            destinatarioGrupo: widget.msgGrupo
                                ? mensagens[0].destinatarioGrupo as Grupo
                                : null,
                            destinatarioUtil: widget.msgGrupo == false
                                ? utilizadorEnvio
                                : null,
                          );

                          MensagemRepository mensagemRepository =
                              MensagemRepository();
                          bool enviou =
                              await mensagemRepository.enviarMensagem(msg);

                          if (!enviou) {
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.ocorreuErro,
                                ),
                              ),
                            );
                          } else {
                            if (mensagemId == 0) {
                              // vamos obter o mensagemid para carregar a consversa

                              MensagemRepository mensagemRepository =
                                  MensagemRepository();
                              int mensagemIdl = await mensagemRepository
                                  .obterUltimoId(utilizadorEnvio!.utilizadorId);

                              setState(() {
                                mensagemId = mensagemIdl;
                              });
                            }
                            // Actualiza a lista de mensagens
                            actualizaDados();
                            setState(() {
                              _isLoading = false;
                              _messageController.clear();
                            });
                          }

                          // Faz scroll para a última mensagem
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          });
                        }
                      },
                      icon: Icon(Icons.send,
                          color: Theme.of(context).canvasColor, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
