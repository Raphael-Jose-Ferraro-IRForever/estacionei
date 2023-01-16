# estacionei

Gerencie seu estacionamento de forma inteligente.

**Importante** Nescessario Logar com uma conta Google pois foi usado para o Auth do Firebase.

Não fiz testes unitarios ainda por falta de tempo e como gostei do projeto fiz algo que pode crescer ao longo do tempo assim como
as funções já informadas no app.

Tem melhorias de SOLID que sei que precisam ser feitas principalmente pela alta dependencia das classes e no service, mas novamente,
não tive tempo para fazer tais melhorias. Também preciso revisar muita coisa porque o firebase mudou bastante e talvez tenha funções 
melhores a se usar.

Link do Figma onde criei o design: https://www.figma.com/file/fjtA6avSR1s9C5CAnmpPXk/Mobile-UI-kit-(Community)?node-id=0%3A1&t=ixJaNfyqBft9SVZr-1

## MobX

flutter packages pub run build_runner build --delete-conflicting-outputs
flutter packages pub run build_runner watch --delete-conflicting-outputs

## build apk

flutter build apk lib/main.dart --release
