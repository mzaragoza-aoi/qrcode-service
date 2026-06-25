require "test_helper"

class QrcodesControllerTest < ActionDispatch::IntegrationTest
  test "shows the generator form" do
    get root_url

    assert_response :success
    assert_select "form"
  end

  test "creates a qr code svg from posted text" do
    post qrcodes_url, params: { text: "https://example.com" }

    assert_response :success
    assert_equal "image/svg+xml", response.media_type
    assert_includes response.body, "<svg"
  end

  test "creates a qr code svg from query text" do
    get qrcode_url, params: { text: "hello" }

    assert_response :success
    assert_equal "image/svg+xml", response.media_type
    assert_includes response.body, "<svg"
  end

  test "rejects blank text" do
    post qrcodes_url, params: { text: "" }

    assert_response :unprocessable_entity
    assert_includes response.body, "Text can&#39;t be blank"
  end
end
