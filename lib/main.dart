import 'package:flutter/material.dart';
import 'package:agenda_generator_flutter/theme.dart';
import 'package:agenda_generator_flutter/theme.dart';
import 'package:intl/intl.dart';
import 'calendar_generator.dart';
import 'pdf_generator.dart';
import 'file_saver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Generator',
      theme: MaterialTheme(Theme.of(context).textTheme).light(),
      home: const AgendaGeneratorPage(),
    );
  }
}

class AgendaGeneratorPage extends StatefulWidget {
  const AgendaGeneratorPage({super.key});

  @override
  State<AgendaGeneratorPage> createState() => _AgendaGeneratorPageState();
}

class _AgendaGeneratorPageState extends State<AgendaGeneratorPage> {
  final TextEditingController _footerMessageController = TextEditingController();
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  String _statusMessage = '';

  @override
  void dispose() {
    _footerMessageController.dispose();
    super.dispose();
  }

  Future<void> _generatePdf() async {
    setState(() {
      _statusMessage = 'Gerando PDF...';
    });

    try {
      final pdfBytes = await PdfGenerator.generateAgendaPdf(
        year: _selectedYear,
        month: _selectedMonth,
        footerMessage: _footerMessageController.text,
      );

      final fileName = 'agenda_${_selectedMonth}_${_selectedYear}.pdf';
      final filePath = await FileSaver.saveFile(fileName, pdfBytes);

      setState(() {
        _statusMessage = 'PDF salvo com sucesso em: $filePath';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao gerar ou salvar PDF: ${e.toString()}';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gerador de Agenda PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _footerMessageController,
              decoration: const InputDecoration(
                labelText: 'Mensagem do Rodapé',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedMonth,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                      });
                    },
                    items: List.generate(12, (index) => index + 1)
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(DateFormat.MMMM().format(DateTime(2000, value))),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<int>(
                    value: _selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedYear = newValue!;
                      });
                    },
                    items: List.generate(10, (index) => DateTime.now().year + index)
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generatePdf,
              child: const Text('Gerar Agenda em PDF'),
            ),
            const SizedBox(height: 16),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }
}

