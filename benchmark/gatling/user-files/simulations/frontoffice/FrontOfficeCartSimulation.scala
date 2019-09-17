import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

object FrontOfficeCartSimulation {
  val httpBaseUrlFO  = System.getProperty("httpBaseUrlFO")
  val cartFeeder = csv("/opt/gatling/user-files/resources/frontoffice-cart.csv").circular

  val buy = scenario("Cart")
    .feed(cartFeeder)
    .exec(http("product display")
      .get(httpBaseUrlFO + "/index.php?id_product=${productId}&controller=product"))
    .pause("${pauseAfterEachStep}")
    .exec(http("product add")
      .post(httpBaseUrlFO + "/index.php?controller=cart&id_product=${productId}&qty=${quantity}&add=1&action=update&ajax=1"))
    .pause("${pauseAfterEachStep}")
    .exec(http("cart display")
      .get(httpBaseUrlFO + "/index.php?controller=cart&action=show"))
    .pause("${pauseAfterEachStep}")
    .exec(http("order #0 : display order")
      .get(httpBaseUrlFO + "/index.php?controller=order"))
    .pause("${pauseAfterEachStep}")
    .exec(http("order #1 : type name")
      .get(httpBaseUrlFO + "/index.php?controller=order&id_customer=&id_gender=${genderId}&firstname=${firstName}&lastname=${lastName}&email=customer@prestashop.com&password=&psgdpr=1&submitCreate=1&continue=1"))
    .pause("${pauseAfterEachStep}")
    .exec(http("order #2  type address and get token")
      .get(httpBaseUrlFO + "/index.php?controller=order&id_customer=&back=&firstname=${firstName}&lastname=${lastName}&id_address=&company=prestashop&address1=${address1}&address2=${address2}&vat_number=&postcode=${postCode}&city=${city}&id_country=${countryId}&phone=&saveAddress=delivery&use_same_address=1&submitAddress=1&confirm-addresses=1")
      .check(css("input[name=token]", "value").saveAs("addressToken"))
    )
    .exec(http("order #2  type address")
      .get(httpBaseUrlFO + "/index.php?controller=order&id_customer=&back=&firstname=${firstName}&lastname=${lastName}&id_address=&company=prestashop&address1=${address1}&address2=${address2}&vat_number=&postcode=${postCode}&city=${city}&id_country=${countryId}&phone=&saveAddress=delivery&use_same_address=1&submitAddress=1&confirm-addresses=1&token=${addressToken}"))
    .pause("${pauseAfterEachStep}")
    .exec(http("order #3 : choose carrier")
      .get(httpBaseUrlFO + "/index.php?controller=order&delivery_option[12]=1,&delivery_message=&confirmDeliveryOption=1"))
    .pause("${pauseAfterEachStep}")

}
