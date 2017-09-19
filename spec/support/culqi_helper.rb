require "spec_helper"

module CulqiHelper
  def setup_culqi_gateway
    Solidus::Gateway::CulqiGateway.create!(
      name: "Culqi",
      preferred_secret_key: "sk_test_SpwICNI4YT0OSLHY",
      preferred_public_key: "pk_test_CaY0noGVG8ohIj4P"
    )
  end

  def checkout_until_payment
    visit spree.product_path(product)
    click_button "Add To Cart"

    # expect(page).to have_current_path("/cart")
    click_button "Checkout"

    # Address
    # expect(page).to have_current_path("/checkout/address")
    fill_in "Customer E-Mail", with: "han@example.com"

    country = Spree::Country.first
    within("#billing") do
      fill_in "First Name", with: "Han"
      fill_in "Last Name", with: "Solo"
      fill_in "Street Address", with: "YT-1300"
      fill_in "City", with: "Mos Eisley"
      select "United States of America", from: "Country"
      select country.states.first, from: "order_bill_address_attributes_state_id"
      fill_in "Zip", with: "12010"
      fill_in "Phone", with: "(555) 555-5555"
    end
    click_on "Save and Continue"

    # Delivery
    # expect(page).to have_current_path("/checkout/delivery")
    # expect(page).to have_content("UPS Ground")
    click_on "Save and Continue"

    # expect(page).to have_current_path("/checkout/payment")
  end
end
