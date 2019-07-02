import 'compiler/Compiler.dart';

main(List<String> args) {
  if (args.length != 1) {
    print('ERRO: O arquivo fonte deve ser informado como parâmetro.');
    return;
  }

  String sourceCode = args[0];
  Compiler compiler = Compiler(sourceCode, 'PROGRAMA.c');
  compiler.compile();
}
