function fn() {
  karate.configure('ssl', true); // enable
  var baseUrlBilletera = 'http://134.209.211.10:5173/'
  var BaseUrl = 'https://petstore.swagger.io/'
  var baseUrlAut =''
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  if (env == 'dev') {
    baseUrlAut = 'https://dummyjson.com'
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }


var config = {
    env: env,
    BaseUrl: BaseUrl,
    myVarName: 'someValue',
    baseUrlAut: baseUrlAut,

urlAuth: 'http://134.209.211.10:4001',
urlWallet: 'http://134.209.211.10:4002',
urlTransaction: 'http://134.209.211.10:4003',
urlAdmin: 'http://134.209.211.10:4004'

}

  return config;
}