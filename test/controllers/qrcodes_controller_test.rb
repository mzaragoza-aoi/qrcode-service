require "test_helper"

class QrcodesControllerTest < ActionDispatch::IntegrationTest
  test "shows the generator form" do
    get root_url

    assert_response :success
    assert_select "form"
  end

  test "creates a centered qr code page from posted text" do
    post qrcodes_url,
      params: { text: "https://example.com", preview: "1" }

    assert_response :success
    assert_equal "text/html", response.media_type
    assert_select ".qr-result-page"
    assert_select ".qr-output svg"
  end

  test "creates a qr code svg from posted text for api requests" do
    post qrcodes_url, params: { text: "https://example.com" }

    assert_response :success
    assert_equal "image/svg+xml", response.media_type
    assert_includes response.body, "<svg"
  end

  test "shows a centered qr code page from query text" do
    get qrcode_url, params: { text: "hello" }

    assert_response :success
    assert_equal "text/html", response.media_type
    assert_select ".qr-result-page"
    assert_select ".qr-output svg"
  end

  test "creates a qr code svg from query text for svg requests" do
    get qrcode_url(format: :svg), params: { text: "hello" }

    assert_response :success
    assert_equal "image/svg+xml", response.media_type
    assert_includes response.body, "<svg"
  end

  test "rejects blank text" do
    post qrcodes_url, params: { text: "", preview: "1" }

    assert_response :unprocessable_entity
    assert_includes response.body, "Text can&#39;t be blank"
  end
end
