require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
    
    test "invalid signup information" do
        # ページを表示する
        get signup_path
        # 式を評価した結果の数値は、ブロックで渡されたものを呼び出す前と呼び出した後で違いがないと主張する。
        assert_no_difference 'User.count' do
            post signup_path, params: { user: {name: "",
                                                email: "user@invalid",
                                                password: "foo",
                                                password_confirmation: "bar"}}
        end
        # そのアクションで指定されたテンプレートが描写されているかを検証
        assert_template 'users/new'
        # アクション実行の結果として描写されるHTMLの内容を検証
        assert_select 'div#error_explanation'
        assert_select 'div.alert'
        assert_select 'form[action="/signup"]'
    end
    
    test "valid signup information" do
       get signup_path
       assert_difference 'User.count',1 do
          post users_path, params: {user: { name: "Example User",
                                            email: "user@example.com",
                                            password:             "password",
                                            password_confirmation:"password" }}
       end
       follow_redirect!
       assert_template 'users/show'
       assert_not flash.empty?
    end
    
end