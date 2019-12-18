import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

object BackOfficeRandomCrawlSimulation {

  val httpBaseUrlBO  = System.getProperty("httpBaseUrlBO")
  val adminUser  = System.getProperty("adminUser")
  val adminPassword  = System.getProperty("adminPassword")

  val headers = Map(
    "Cache-Control" -> "no-cache",
    "Content-Type" -> "application/x-www-form-urlencoded",
    "Pragma" -> "no-cache")

  val pageFeeder = csv("/opt/gatling/user-files/resources/backoffice-urls.csv").random
  // pause between 0 and 10 s
  def randomPauseDuration() = scala.util.Random.nextInt(10)
  // page count between 20 and 50
  def randomPageCount() = 20 + scala.util.Random.nextInt(30)

  val browseBO = scenario("Browse BO random")
    .exec(http("BackOfficeRandomCrawl " + "backoffice index")
        .get(httpBaseUrlBO + "/index.php?controller=AdminLogin"))
        .pause(2)
    // admin authentication
    .exec(http("BackOfficeRandomCrawl " + "authenticate")
      .post(httpBaseUrlBO + "/index.php?rand=1524833450885")
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
    // loop over 50 random pages on the BO
    .repeat(randomPageCount()) {
      feed(pageFeeder)
      .exec(http("BackOfficeRandomCrawl " + "${name}")
        .get(httpBaseUrlBO + "${location}"))
        .pause(randomPauseDuration())
    }
}
