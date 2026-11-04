import com.intuit.karate.junit5.Karate;

public class KarateRunner {

    public static void main(String[] args) {
        // Configurar el TrustStore
        System.setProperty("javax.net.ssl.trustStore", "C:\\Program Files\\Java\\jdk-17\\lib\\security\\cacerts");
        System.setProperty("javax.net.ssl.trustStorePassword", "changeit");

        // Aquí puedes agregar el resto de tu código
        // Por ejemplo, iniciar tus pruebas con Karate
    }
    @Karate.Test
    Karate testSample() {
        return Karate.run("classpath:api_soap/test-soap.feature").relativeTo(getClass());
    }
}
