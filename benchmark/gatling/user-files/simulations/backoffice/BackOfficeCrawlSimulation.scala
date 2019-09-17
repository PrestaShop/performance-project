import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

object BackOfficeCrawlSimulation {

  val httpBaseUrlBO  = System.getProperty("httpBaseUrlBO")
  val adminUser  = System.getProperty("adminUser")
  val adminPassword  = System.getProperty("adminPassword")

  val headers = Map(
    "Cache-Control" -> "no-cache",
    "Content-Type" -> "application/x-www-form-urlencoded",
    "Pragma" -> "no-cache")

  val pageFeeder = csv("/opt/gatling/user-files/resources/backoffice-urls.csv").circular

  val browseBO = scenario("Browse BO")
    .exec(http("backoffice index")
        .get(httpBaseUrlBO + "/index.php?controller=AdminLogin"))
        .pause(2)
    // admin authentication
    .exec(http("authenticate")
      .post(httpBaseUrlBO + "/index.php?rand=1568639660308")
      .headers(headers)
      .formParam("ajax", "1")
      .formParam("token", "")
      .formParam("controller", "AdminLogin")
      .formParam("submitLogin", "1")
      .formParam("email", adminUser)
      .formParam("passwd", adminPassword)
      .formParam("redirect", httpBaseUrlBO)
      .formParam("stay_logged_in", "1"))
      .pause(3)
    // repeat will loop into csv feeder, each time it loads only one page
    .repeat(30) {
      feed(pageFeeder)
      .exec(http("${name}")
        .get(httpBaseUrlBO + "${location}"))
        .pause("${pauseAfter}")
    }
}
