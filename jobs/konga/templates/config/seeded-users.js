<%
    require "json"
    def esc(x)
        x.to_json
    end
-%>
module.exports = [
        {
            "username": <%= esc(p("admin.username")) %>,
            "email": <%= esc(p("admin.email")) %>,
            "firstName": <%= esc(p("admin.first_name")) %>,
            "lastName": <%= esc(p("admin.last_name")) %>,
            "admin": true,
            "active" : true,
            "password": <%= esc(p("admin.password")) %>
        }
    ]
