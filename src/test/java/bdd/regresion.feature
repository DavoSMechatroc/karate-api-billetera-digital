@regresion
Feature: Regresion de billetera digital

  Background: Configuracion inicial
    * configure headers = { 'x-channel': 'POSTMAN' }


  @prepararUsuarios
  Scenario: Registrar usuario emisor y receptor

  # Funcion para generar celulares aleatorios
    * def generarCelular = function() { return '9' + Math.floor(10000000 + Math.random() * 90000000) }

  # Variables de los usuarios
    * def phoneEmisor = generarCelular()
    * def phoneReceptor = generarCelular()
    * def pinUsuarios = '123456'

  # Registrar usuario emisor
    Given url urlAuth
    And path '/auth/v1/register'
    And request
  """
  {
    "phone": "#(phoneEmisor)",
    "fullName": "Emisor Prueba",
    "email": "#('emisor' + phoneEmisor + '@test.com')",
    "pin": "#(pinUsuarios)"
  }
  """
    When method post
    Then status 201
    And match response.message == 'Usuario creado exitosamente'
    And match response.user.id == '#string'
    * def emisorCreado = response.user
    * print 'Usuario emisor:', emisorCreado

  # Registrar usuario receptor
    Given url urlAuth
    And path '/auth/v1/register'
    And request
  """
  {
    "phone": "#(phoneReceptor)",
    "fullName": "Receptor Prueba",
    "email": "#('receptor' + phoneReceptor + '@test.com')",
    "pin": "#(pinUsuarios)"
  }
  """
    When method post
    Then status 201
    And match response.message == 'Usuario creado exitosamente'
    And match response.user.id == '#string'
    * def receptorCreado = response.user
    * print 'Usuario receptor:', receptorCreado

  # ----------------------DEFINIMOS PARA LA RECARGA --------------------------

  # URL del servicio de billetera
    * def montoRecarga = 1000

  # Login del emisor
    Given url urlAuth
    And path '/auth/v1/login'
    And request { phone: '#(phoneEmisor)', pin: '#(pinUsuarios)' }
    When method post
    Then status 200
    * def tokenEmisor = response.token
    And match tokenEmisor == '#string'

  # Recargar saldo del emisor
    Given url urlWallet
    And path '/wallet/v1/deposit'
    And header Authorization = 'Bearer ' + tokenEmisor
    And request { amount: '#(montoRecarga)' }
    When method post
    Then status 200
    And match response.success == true
    * def saldoRecargaEmisor = response.newBalance

  # Consultar saldo del emisor
    Given url urlWallet
    And path '/wallet/v1/balance'
    And header Authorization = 'Bearer ' + tokenEmisor
    When method get
    Then status 200
    And match response.balance == saldoRecargaEmisor
    * def saldoInicialEmisor = response.balance
    * print 'Saldo inicial emisor:', saldoInicialEmisor

  # Login del receptor
    Given url urlAuth
    And path '/auth/v1/login'
    And request { phone: '#(phoneReceptor)', pin: '#(pinUsuarios)' }
    When method post
    Then status 200
    * def tokenReceptor = response.token
    And match tokenReceptor == '#string'

  # Recargar saldo del receptor
    Given url urlWallet
    And path '/wallet/v1/deposit'
    And header Authorization = 'Bearer ' + tokenReceptor
    And request { amount: '#(montoRecarga)' }
    When method post
    Then status 200
    And match response.success == true
    * def saldoRecargaReceptor = response.newBalance

  # Consultar saldo del receptor
    Given url urlWallet
    And path '/wallet/v1/balance'
    And header Authorization = 'Bearer ' + tokenReceptor
    When method get
    Then status 200
    And match response.balance == saldoRecargaReceptor
    * def saldoInicialReceptor = response.balance
    * print 'Saldo inicial receptor:', saldoInicialReceptor


      # Datos que utilizaremos en los siguientes escenarios
    * def datosPrueba = { phoneEmisor: '#(phoneEmisor)', phoneReceptor: '#(phoneReceptor)', pinUsuarios: '#(pinUsuarios)', emisorId: '#(emisorCreado.id)', receptorId: '#(receptorCreado.id)', saldoInicialEmisor: '#(saldoInicialEmisor)', saldoInicialReceptor: '#(saldoInicialReceptor)' }

  @transferencia
  Scenario: Transferir saldo del emisor al receptor

  # Preparar los usuarios
    * def preparacion = callonce read('classpath:bdd/regresion.feature@prepararUsuarios')
    * def datos = preparacion.datosPrueba

# Datos para transferencia
    * def montoTransferencia = 450

  # Login del emisor
    Given url urlAuth
    And path '/auth/v1/login'
    And request
  """
  {
    "phone": "#(datos.phoneEmisor)",
    "pin": "#(datos.pinUsuarios)"
  }
  """
    When method post
    Then status 200
    * def tokenTransferencia = response.token
    And match tokenTransferencia == '#string'

  # Realizar transferencia
    Given url urlTransaction
    And path '/transaction/v1/transfer'
    And header Authorization = 'Bearer ' + tokenTransferencia
    And request
  """
  {
    "recipientId": "#(datos.receptorId)",
    "amount": 450,
    "description": "Pago de Servicios",
    "categoryId": "cat_food_1"
  }
  """
    When method post
    Then status 200
    And match response.status == 'COMPLETED'
    And match response.transactionId == '#string'
    * def codigoTransaccion = response.transactionId

  # Consultar saldo actual del emisor
    Given url urlWallet
    And path '/wallet/v1/balance'
    And header Authorization = 'Bearer ' + tokenTransferencia
    When method get
    Then status 200

  # Validar disminucion de saldo
    * def saldoEsperadoEmisor = datos.saldoInicialEmisor - montoTransferencia
    And match response.balance == saldoEsperadoEmisor

    * print 'Codigo de transaccion:', codigoTransaccion
    * print 'Saldo final emisor:', response.balance

  @validarReceptor
  Scenario: Validacion de transferencia en receptor

    # Preparar usuarios y ejecutar transferencia
    * def resultadoTransferencia = callonce read('classpath:bdd/regresion.feature@transferencia')
    * def datos = resultadoTransferencia.datos
    * def montoTransferencia = resultadoTransferencia.montoTransferencia
    * def codigoTransaccion = resultadoTransferencia.codigoTransaccion

  # Login del receptor
    Given url urlAuth
    And path '/auth/v1/login'
    And request
  """
  {
    "phone": "#(datos.phoneReceptor)",
    "pin": "#(datos.pinUsuarios)"
  }
  """
    When method post
    Then status 200
    * def tokenReceptorValidacion = response.token
    And match tokenReceptorValidacion == '#string'

  # Consultar saldo del receptor
    Given url urlWallet
    And path '/wallet/v1/balance'
    And header Authorization = 'Bearer ' + tokenReceptorValidacion
    When method get
    Then status 200

  # Validar incremento del saldo
    * def saldoEsperadoReceptor = datos.saldoInicialReceptor + montoTransferencia
    And match response.balance == saldoEsperadoReceptor

  # Mostrar resultados
    * print 'Saldo inicial receptor:', datos.saldoInicialReceptor
    * print 'Monto recibido:', montoTransferencia
    * print 'Saldo final receptor:', response.balance
    * print 'ID de transferencia:', codigoTransaccion