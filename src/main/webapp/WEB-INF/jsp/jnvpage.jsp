<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style media="screen">
        small {
            color: red;
        }
        
        * {
            margin: 0;
            padding: 0;
        }
        
        html {
            scroll-behavior: smooth;
            font-family: tahoma;
        }
        
        h1 {
            text-align: center;
            position: fixed;
            top: 0;
            left: 35%;
            color: purple;
        }
        
        ul {
            list-style: none;
            height: 50px;
            width: 100%;
            position: fixed;
            top: 0;
            left: 0;
            background: crimson;
            box-shadow: 2px 0px 5px black;
            display: flex;
            justify-content: space-around;
        }
        
        .content {
            display: flex;
            width: 500%;
        }
        
        ul li {
            margin: 5px;
            padding: 5px;
        }
        
        ul li a {
            color: white;
            text-decoration: none;
            font-size: 20px;
            padding: 5px;
        }
        
        ul li a:hover {
            background: white;
            color: blue;
        }
        
        section {
            height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
            text-transform: uppercase;
        }
        
        #section1 {
            background: linear-gradient(-45deg, white 30%, rgb(216, 183, 226) 0%);
        }
        
        #section2 {
            background: linear-gradient(-45deg, white 30%, rgb(164, 209, 164) 0%);
        }
    </style>
    <script>
        function validateUserName() {
            var status = true;
            var username = document.getElementById("username").value;
            var usernameError = document.getElementById("usernameError");
            if (username.length == 0) {
                usernameError.innerHTML = "username required";
                status = false;
            } else {
                usernameError.innerHTML = "";
                return status;
            }
        }
        function validatePassword() {
            var status = true;
            var password = document.getElementById("password").value;
            var passwordError = document.getElementById("passwordError");
            var regEx = "^(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).*$";
            var result = password.match(regEx);
            if (result == null) {
                passwordError.innerHTML = "password must contain 8 letter, 1 uppercase 1 lowercase 1 specialcase";
                status = false;
            } else {
                passwordError.innerHTML = "";
                return status;
            }
        }
        function validateMobile() {
            var status = true;
            var mobile = document.getElementById("mobile").value;
            var mobileError = document.getElementById("mobileError");
            if (mobile.length == 0) {
                status = false;
                mobileError.innerHTML = "mobile number required"
            } else if (mobile.length != 10) {
                status = false;
                mobileError.innerHTML = "must contain 10 digit";
            } else if (isNaN(mobile)) {
                status = false;
                mobileError.innerHTML = "must be a number";
            } else {
                mobileError.innerHTML = "";
                return status;
            }
        }
        function validateData() {
            var status = true;
            var usernameStatus = validateUserName();
            if (validateStatus == false) {
                return false;
            }
            var passwordStatus = validatePassword();
            if (passwordStatus == fale) {
                return false;
            }
            var mobileStatus = validateMobile();
            if (mobileStatus == false) {
                return false;
            }
            if (status) {
                alert("Registeration sucess")
                return status;
            }
            function showPassword() {
                var passwordInputField = document.getElementById("password");
                passwordInputField.type = "text";
            }
        }
    </script>
</head>

<body>
    <ul>
        <li><a href="#section1">Registration</a></li>
        <li><a href="#section2">Login</a></li>

    </ul>

    <div class="content">
        <section id="section1">
            <div class="container">
           
                <form action="savejnv" method="post">
                    <div class="form-group">
                    	ID
                    	<input type="number" name="id" class="form-control">
                    	<div>
                        UserName
                        <input type="text" name="username" onkeyup="validateUserName()" id="username" class="form-control" required>
                        <small id="usernameError"></small>
                    </div>

                    <div>
                        password
                        <input type="password" name="password" onkeyup="validatePassword()" maxlength=10 id="password" class="form-control" required>
                        <small id="passwordError"></small>
                    </div>
                    <div>
                        Mobile
                        <input type="number" name="mobile" onkeyup="validateMobile()" id="mobile" class="form-control" required/>
                        <small id="mobileError"></small>
                    </div>
                    <div>
                        Email
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div>
                        City
                        <input type="text" name="city" class="form-control" required>
                    </div>

                    <br>
                    <div class="form-group">
                        <button onclick="validateData()" type="submit" class="btn btn-primary">Register</button>

                    </div>
                </form>
               
            </div>
			<a href="/updateData" ><button class="btn btn-primary">Update</button></a>
			<a href="/listall" ><button class="btn btn-primary">List All</button></a>
        </section>
        <section id="section2">
            <div class="container">
                <form action="jnvlogin" object="jnv" method="post">
                    <div class="form-group">
                        <label>Username</label>
                        <input onkeyup="validateUserName()" type="text" id="username" class="form-control" />
                        <small id="usernameError"></small>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input onkeyup="validatePassword()" type="password" id="password" maxlength=10 class="form-control" />
                        <small id="passwordError"></small>
                       
                    </div>
                    <div class="form-group">
                        <button onclick="return validateData()" type="submit" class="btn btn-primary">Login</button>
                    </div>
                </form>
               
                ${msg}
            </div>
        </section>

    </div>
</body>

</html>