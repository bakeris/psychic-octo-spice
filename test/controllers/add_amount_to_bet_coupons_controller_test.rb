require 'test_helper'

class AddAmountToBetCouponsControllerTest < ActionController::TestCase
  test "should get amount:string" do
    get :amount:string
    assert_response :success
  end

end
