import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';


String privacyPolicyUrl = "https://flutter.dev";


Map<int, dynamic> data = {
  0: {
    "name": "Yo Ahorro",
    "initialData": "En la herramienta Yo Ahorro, La fundación Mundo Mujer le ofrece una calculadora de ahorros. Esta le ayudará a optimizar y visualizar qué tan alcanzables son sus sueños y cómo, gracias al buen ahorro, puede alcanzarlos.",
    "discription": "El ahorro es la acción de separar una parte de los ingresos de una persona o empresa, con el fin de guardarlo para futuros usos. Ya sea para gastos previstos o imprevistos.",
    "explaination": "Primero deberá ingresar un valor para sus necesidades y ahorros. Luego tendrá que rellenar el valor de sus aspiraciones y en cuánto tiempo desea alcanzarlos. Finalmente tiene que calcular cuánto tendría que ahorrar para lograrlo. En caso de que coincida con el valor de arriba, ganará  el juego.",
    "color": Color(0xff17467A)
  },
  1: {
    "name": "Yo Me Aseguro",
    "initialData": "En el juego Yo Me Aseguro, se divertirá y aprenderá el valor de tener su vehículo bien asegurado. Es un juego rápido donde la buena conducción y acumulación de seguros marcará la diferencia para poder llegar a salvo a su casa. Podrá escoger entre carro, moto e incluso ciudad, bosque o desierto.",
    "discription": "Los seguros son contratos en los cuales a cambio de cobrar una prima (precio del seguro), la entidad aseguradora se compromete en caso de que se produzca algún siniestro cubierto por dicho contrato, a indemnizar el daño producido, satisfacer un capital (o renta) u otra prestación convenida.",
    "explaination": "En este juego deberá conducir con un carro o una moto por la ciudad, el bosque o el desierto. La finalidad es aprender la importancia de tener un seguro que le respalde.",
    "color": Color(0xffF8CD35)
  },
  2: {
    "name": "Yo Llevo Mis Cuentas",
    "initialData": "Con esta herramienta podrá organizar piscinas de inversión cooperativas llevando siempre las cuentas claras.",
    "discription": "¿Qué son las cuentas?\n\nSon el conjunto de cifras y datos (de las operaciones económicas) que realiza una entidad o empresa, recogidos y anotados según determinados métodos. Lo ideal es tener en orden tus ganancias, cuánto gastas y cuánto necesitas",
    "explaination": "El objetivo del juego de habilidad es llevar las cuentas claras. Esto se logrará recordando las cartas y eligiendo la correcta en el desafío. Con respecto a la herramienta, le ayudará a tener un mejor control de sus cuentas",
    "color": Color(0xff8EA5C2)
  },
  3: {
    "name": "Deudas Sanas",
    "initialData": "En la herramienta \"Deudas Sanas\", usted tendrá que decidir, en un caso hipotético, cuánto tiene que prestarle el banco para su educación. Deberá colocar cuánto paga por su arriendo, su salud y gastos varios. Luego deberá ingresar la cifra que gana mensualmente. Con estos datos, la aplicación arrojará el resultado correcto de cuánto deberá pagar por mes para no endeudarse.",
    "discription": "La deuda es una obligación que tiene una persona física o jurídica para cumplir sus compromisos de pago, fruto del ejercicio de su actividad económica",
    "explaination": "Inserta en los campos la información requerida. El primer campo corresponde a la totalidad del préstamo o deuda. El siguiente al interés y el último a cuánto puedes pagar por mes. Con esto podrás saber cuántos meses demorarás en cancelar el saldo total. ",
    "color": Color(0xffF6892B)
  },
  4: {
    "name": "Trabajo en Comunidad",
    "initialData": "En el juego Trabajo en Comunidad, aprenderá lo valioso que es el trabajo en equipo. A su vez, también podrá entretenerse y descubrir cómo se puede ganar con la ayuda de la comunidad. Tenga en cuenta que la clave está en aceptar la ayuda de más granjeros cuando la ocasión lo requiera.",
    "discription": "El trabajo social comunitario es un proceso que se realiza para el bienestar social. El modo de conseguir este fin, es siempre a través de la utilización, potenciamiento o creación de recursos. La propia comunidad es el principal recurso para tener en cuenta en cualquier intervención comunitaria.",
    "explaination": "En este juego deberá comenzar con su granjero. Progresivamente deberás solicitar la ayuda de los demás para poder ganar en comunidad.",
    "color": Color(0xff0072B2)
  },
  5: {
    "name": "Servicios Financieros",
    "initialData": "En el apartado Servicios Financieros, aprenderá cuáles son las oportunidades existentes en el mercado económico actual.",
    "discription": "Son los servicios económicos proporcionados por la industria financiera. Estos abarcan una amplia gama de negocios que administran dinero como: uniones  de crédito, los bancos, las compañías de tarjetas de crédito, de seguros, de contabilidad, de financiamiento al consumo, las casas de bolsa, los fondos de inversión, gerenciadoras individuales y algunas empresas patrocinadas por el gobierno.",
    "explaination": "En este módulo de aprendizaje, conocerá cómo diferentes servicios financieros pueden ayudarle a lograr sus metas. Le brindaremos las herramientas claves para descubrir el servicio adecuado que le ayude a cumplir su objetivo. Además, aprenderá sobre los servicios financieros y los conceptos que manejan los bancos.",
    "color": Color(0xff8EA5C2)
  },
  6: {
    "name": "Mi Cajero Automático",
    "initialData": "En este simulador de cajeros, conocerá el uso cotidiano de un cajero automático. Podrá seleccionar una de las 3 casillas, las cuales le llevarán a un juego donde aprenderá las distintas partes de un cajero: cómo retirar dinero, cómo consultar el saldo disponible en la cuenta y otras actividades realizables.",
    "discription": "En la simulación de Cajero Automático aprenderá sus principales opciones. Podrá cambiar su contraseña, retirar dinero y consultar su saldo disponible.",
    "explaination": "En este simulador podrá consultar su saldo, cambiar de contraseña y retirar dinero. De esta manera aprenderá lo esencial de un cajero automático",
    "color": Color(0xffF8CD35)
  },
  7: {
    "name": "Bajo Presión",
    "initialData": "En la serie de juegos de Bajo presión, podrá saber con criterio propio, qué tan estresantes pueden ser los números. El endeudamiento podría generar estrés y ponernos bajo presión, pero no se preocupe. aquí solo desarrollará agilidad mental al mismo tiempo que se divierte superando retos.",
    "discription": "El endeudamiento y mal control de las finanzas son las causas principales del estrés financiero. Este como cualquier otro tipo de estrés, provoca el aumento de la presión arterial, genera ansiedad, problemas de sueño y depresión.\n\nLo mejor para su salud es evitarlo y llevar una vida financiera sana, sin deudas ni excesos.",
    "explaination": "En este apartado podrá ir desbloqueando desafíos con sus facultades cerebrales. Cada desafío superado supone un mayor nivel de reto. ",
    "color": Color(0xffF6892B)
  },
  8: {
    "name": "Decisiones Arriesgadas",
    "initialData": "Aprenda a darse cuenta entre decisiones financieras arriesgadas y decisiones o inversiones de poco riesgo. Responderá una serie de preguntas y conseguirá dominarlas en su totalidad. ",
    "discription": "En Decisiones Arriesgadas, tendrá la opción de realizar una corta encuesta. En esta, podrá descubrir cuáles son sus habilidades para administrar sus finanzas.",
    "explaination": "Tome una encuesta de riesgo y conozca qué tan buenas son sus finanzas. Recuerde: un buen balance entre prudencia y decisión puede ser la fórmula del éxito.",
    "color": Color(0xff0072B2)
  },
  9: {
    "name": "Tentaciones",
    "initialData": "En este juego de destreza, deberá deslizar la canasta de derecha a izquierda intentando atrapar lo que más pueda. Deberá tener en cuenta qué cosas son o no necesarias dependiendo de la ocasión. No te dejes llevar por la tentación y elige sabiamente.",
    "discription": "En el juego \"Tentaciones\", podrá entretenerse mientras aprende lo caro que puede costar al principio darse un lujo. Ten en cuenta que primero debes cubrir las necesidades antes de optar por cosas secundarias.",
    "explaination": "En este juego podrá aprender lo importante que es priorizar necesidades antes que lujos. Tiene que recolectar en total 20 objetos necesarios y de esa forma ganará el juego.",
    "color": Color(0xffFFF200)
  },
  10: {
    "name": "Salud Económica",
    "initialData": "En el apartado \"Salud Económica\", recibirá consejos para poder administrar sus finanzas de la forma correcta. Con el aprendizaje brindado, podrá comenzar su viaje definitivo a la prosperidad económica.",
    "discription": "La salud económica se logra administrando sus finanzas de forma saludable por medio de la práctica de buenos hábitos financieros.",
    "explaination": "En este apartado tendrá dos opciones para elegir cuando quiera. Cualquiera de ellas le proporcionará conocimiento vital para el manejo de sus finanzas.",
    "color": Color(0xff17467A)
  },
  11: {
    "name": "Salud Económica",
    "initialData": "En el apartado \"Salud Económica\", recibirá consejos para poder administrar sus finanzas de la forma correcta. Con el aprendizaje brindado, podrá comenzar su viaje definitivo a la prosperidad económica.",
    "discription": "La salud económica se logra administrando sus finanzas de forma saludable por medio de la práctica de buenos hábitos financieros.",
    "explaination": "En este apartado tendrá dos opciones para elegir cuando quiera. Cualquiera de ellas le proporcionará conocimiento vital para el manejo de sus finanzas.",
    "color": Color(0xff17467A)
  },
};

Map<String, dynamic> chat_qa = {
  "¿Puedo consignar cheques en mi cuenta de ahorros y cuánto se demora un cheque en hacer canje?":
      "Se pueden consignar cheques en las cuentas de ahorro y estará disponible el dinero en tres días hábiles. Se debe tener en cuenta que las operaciones realizadas en horario adicional, se consideran como realizadas al siguiente día hábil y se entiende por horario adicional toda transacción que se realiza después de las 3:00 pm.",
  "¿Recibiré extractos para todos los productos que tenga con el Banco?":
      "Tanto para los créditos como para las cuentas de ahorro, el banco entregará los extractos por demanda. Los clientes que lo requieran podrán acceder a ellos solicitándolos en las oficinas del Banco y se entregarán de manera inmediata.",
  "¿Los retiros de las cuentas pagan el 4 por mil?":
      "No se pagará el 4 por mil siempre y cuando la cuenta de ahorros haya sido marcada como exenta y recordemos que un cliente solo podrá tener una cuenta marcada como exenta en todo el sistema financiero.",
  "¿Cuál es el plazo mínimo para abrir un CDT?": "30 Días.",
  "¿Puedo cancelar mi CDT antes de la fecha de vencimiento?":
      "No se permiten cancelaciones anticipadas.",
  "¿Cuál es el costo de apertura de un CDT?": "Abrir un CDT, no tiene costo.",
  "¿Cuántos días pueden pasar después del vencimiento de un CDT para realizar su respectiva liquidación?":
      "Los certificados de depósito son a término, lo que indica que el día de su vencimiento se debe tomar la decisión de cancelarlo o prorrogarlo.",
  "¿Se podrán realizar transacciones por la página web del Banco?": [
    "Actualmente la página web del Banco no estará habilitada para realizar transacciones, únicamente se podrán realizar:",
    "Consultas de información general de productos y servicios.",
    "Radicación de peticiones, quejas y reclamos.",
    "Solicitud de créditos.",
    "Solicitud de productos de ahorro."
  ],
  "¿Quiénes pueden tener un crédito en Mundo Mujer?":
      "Ofrecemos créditos a Mujeres y Hombres, mayores de edad, dedicados a negocios de comercio, producción o servicios. Financiamos a las personas dedicadas al sector agropecuario con cultivo o cría de animales y hacemos préstamos a empleados y pensionados.",
  "¿Es necesario haber tenido crédito en otra entidad?":
      "No, en Mundo Mujer no exigimos contar con historial crediticio. Gran parte de nuestros clientes se han vinculado a nuestra Institución sin haber tenido crédito antes con otra entidad.",
  "¿Cómo puedo solicitar un crédito en Mundo Mujer?": [
    "Solicitar un crédito en Mundo Mujer es muy fácil: Puede acudir a cualquiera de nuestras oficinas en el país o a través de nuestra Línea Gratuita Nacional, llamando gratis desde cualquier lugar a la línea 018000 910 666.",
    "También a través de nuestra página web: ",
    "Formulario de Pre-solicitud"
  ]
};

Map<int, dynamic> game1Data = {
  0: {
    'title': 'Ahorre por usted mismo',
    'data': 'No se limite a automatizar sus ahorros y comience a ahorrar sí mismo. Es posible que se sorprenda de cuánto dinero adicional puede ahorrar si transfiere una cantidad fija a su cuenta de ahorros cada vez que cobre. Incluso si tiene las mejores intenciones de ahorrar, la vida pasa y podría terminar gastando su dinero. Esto lo puede evitar por medio de una transferencia mensual fija a su cuenta, para luego poder disponer libremente de lo restante.',
  },
  1: {
    'title': 'Gastar conscientemente',
    'data': 'De la misma manera, aprender a gastar de manera consciente puede brindarle paz financiera y alegría a su vida. Esto puede ser difícil de implementar al principio, e incluso puede recibir rechazo de amigos y familiares a medida que cambia en qué gasta su dinero. Pero al final, valdrá la pena. Dedique un tiempo a reflexionar sobre cómo realmente quiere que sea su vida. Luego tome pequeños pasos para cambiar sus gastos y reflejar su estilo de vida ideal, sin importar si eso significa tener dinero para viajar, mudarse o incluso gastar dinero en salir a comer con regularidad. Muchos valoramos esto, pero los excesos son malos.',
  },
  2: {
    'title': 'Seguimiento de sus gastos',
    'data': 'Antes de hacer un primer presupuesto, debe realizar seguimiento de sus gastos. Esto ayudará a corregir el gasto excesivo casi automáticamente, porque de esta forma, podrá ver a dónde va su dinero y realizar cambios de ser necesario. Podría considerar optar por un plan de gastos en efectivo únicamente para las áreas donde el gasto excesivo tiende a frecuentarse. Por ejemplo, salir a cenar, entetenimiento y golosinas. Pero si siente que el efectivo no es tan conveniente como le gustaría, también puede usar una tarjeta de débito en una cuenta bancaria separada, con un saldo preestablecido cada mes. Opte por la protección contra sobregiros, de manera a que cuando agote su dinero, no pueda seguir comprando. Puede realizar un seguimiento de sus gastos con una simple hoja de cálculo, una aplicación o incluso con lápiz y papel.',
  },
  3: {
    'title': 'Automatice tus finanzas',
    'data': 'Una de las mejores cosas que puede hacer para sus finanzas, es automatizarlas lo máximo posible. Tenemos muchas cosas diariamente en las cuales pensar, es por eso que si automatiza sus finanzas tendrá una cosa menos de la cual preocuparse. Esta es la razón principal por la cual se automatizan los pagos y transferencias a la cuenta de ahorros. De esta manera podrá construir su fondos de reserva sin siquiera pensarlo.',
  },
  4: {
    'title': 'Cambiar de Crédito a Débito',
    'data': 'Uno de los mejores hábitos que puede adoptar, si es propenso al gasto excesivo y a endeudarse con las tarjetas de crédito, es solamente usar débito. Las tarjetas de débito ofrecen un límite natural con respecto a cuánto puede gastar, ya que solo puede gastar hasta que se vacíe su cuenta. No hay peligro de acumular deudas con altos intereses, que podrían tardar años en liquidarse. Una vez más, asegúrese de incluirse a la protección contra sobregiros.',
  },
  5: {
    'title': 'Pague extra en su deuda',
    'data': 'Si tiene la mala costumbre de pagar el mínimo de su deuda, es hora de cambiar a mejores hábitos. Saldar más de su deuda, hará que pueda pagarla más rápido. Incluso si no tiene mucho dinero extra, unos pocos pesos pueden marcar la diferencia en gran medida. Para evitar que su dinero genere más deudas, es mejor administrarlo en las deudas activas cada vez que tenga dinero de extra.',
  },
  6: {
    'title': 'Empiece a invertir',
    'data': 'Al igual que ahorrar por sí mismo, también debe asegurarse de que se ha ocupado de su futuro mediante la inversión para la jubilación y otras necesidades futuras. La forma más facil de comenzar a invertir es contribuyendo a su plan de jubilación patrocinado por su empleador (en caso de existir alguno). Muchos empleadores ofrecerán a sus empleados una equiparación de sus contribuciones. En caso de no tener plan de jubilación patrocinado por su empleador, aún puede invertir. Abra una cuenta que le permita ahorrar y generar ganancias porcentuales por hacerlo.',
  },
  7: {
    'title': 'No dejes que los malos días te depriman',
    'data': 'No importa cuánto avance en sus finanzas, todos seguimos cometiendo errores a veces y tenemos días malos. Podríamos tomar una mala decisión financiera o encontrarnos con algunos gastos imprevistos, pero la clave para superarlo y retomar el rumbo es aprender a aceptarlas y seguir adelante. Por supuesto, debe aprender de sus errores, pero no se castigue por ellos.',
  },
  8: {
    'title': 'Practique la gratitud',
    'data': 'Otro cambio financiero bueno es practicar la gratitud a diario. Puede que no suene como un hábito financiero, pero puede marcar la diferencia. Cuando practica la gratitud por el mundo que le rodea, se sentirá menos presionado para \"seguir el ritmo\" de los demás. No tiene que comprar cosas que no necesita realmente. Porque alguien adquiera algo mejor, no quiere decir que debemos estar celosos o querer lo mismo. Debemos sentirnos agradecidos con lo que tenemos.',
  },
  9: {
    'title': 'Tenga en cuenta sus objetivos finales',
    'data': 'Cuando se está trabajando para mejorar las finanzas, puede ser fácil olvidar por qué comenzó en primer lugar. Este año, genere el hábito de tener en cuenta sus objetivos finales. Cuando las cosas se pongan difíciles, debe resistir. Sus objetivos financieros deberían ser suficientes para mantenerse motivado para avanzar con sus finanzas.',
  }
};

Map<int, dynamic> game2Data = {
  0: {
    'title': 'Comience a prestar dinero',
    'data':
        """Si el dinero lo gasta, no vuelve. Pero si en cambio, lo presta, vuelve multiplicado. Eso es invertir en términos financieros.

Cuando se habla de prestar dinero no es para personales, sino para colocarlo en plazos fijos. Colocar en fondos de inversión, deudas expedidas por bancos con promesas de pago e intereses adicionales, bonos, adquirir acciones a largo plazo u otros instrumentos de renta fija.

En todos estos casos nos convertiremos en oferentes de capital en vez de demandantes. Prestaremos dinero y regresará con ganancias adicionales.

Por supuesto, para prestar dinero antes hay que estar libre de deudas. De esta forma, nos ubicaremos en el grupo de los acreedores y no en el de los morosos.

Comenzar a prestar dinero es un ítem que no puede faltar en una buena lista financiera.""",
    'score': 3
  },
  1: {
    'title': 'No se olvide de emprender',
    'data':
        """Cuando se habla de emprender, se refiere a cualquier tipo de actividad que  genere ingresos por fuera de su trabajo en relación de dependencia.

Hoy en día, gracias a Internet, las barreras para convertirse en su propio jefe disminuyeron significativamente. Esta tendencia continúa a medida que se multiplican los mercados y plataformas online donde podemos fácilmente poner a prueba nuestras ideas comerciales.

Comenzar a ganar dinero por fuera de su trabajo habitual, le abrirá nuevos caminos y modalidades de ingresos, que podrá luego comparar con lo que percibe en su empleo de dependencia. Deberá determinar cuál pesa más en su ingreso mensual y cuánto tiempo demanda cada uno.""",
    'score': 3
  },
  2: {
    'title': 'Aplica la regla 50-30-20',
    'data':
        """Una buena forma de estructurar sus ingresos, es derivar el 50% a los gastos fijos, el 30% a los gastos deseados y transformar el 20% restante en ahorro.

Para cumplir esta regla, sin tentarte y ceder a consumos innecesarios, es conveniente aplicar el principio de "Ahorre por usted mismo", que consiste en separar el 20% destinado al ahorro de entrada, para que no se confunda con el resto y se pierda en gastos fijos o deseados.

Llevar un registro completo de nuestros gastos, detallando el monto y su naturaleza, constituye un paso fundamental para cumplir una regla que tampoco puede quedar afuera en su lista financiera.""",
    'score': 4
  },
};

Future<bool> onWillPop(bool isExit, context, Size size) {
  return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(
            '¿Estas seguro?',
            textAlign: TextAlign.center,
          ),
          content: isExit == true
              ? Text('¿Quieres salir de una aplicación?',
                  textAlign: TextAlign.center)
              : Text('¿Quieres salir de una juego?',
                  textAlign: TextAlign.center),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'No',
              ),
            ),
            FlatButton(
              onPressed: () =>
                  isExit == true ? exit(0) : Navigator.of(context).pop(true),
              child: Text(
                'Si',
              ),
            ),
          ],
        ),
      ) ??
      false;
}

void buttonClick() {
  final assetsAudioPlayer = new AssetsAudioPlayer();
  assetsAudioPlayer.setVolume(1);
  assetsAudioPlayer
      .open(
        Audio("asset/audio/button.m4a"), volume: 0.35
      )
      .then((value) => assetsAudioPlayer.play());
  print("play");
}
