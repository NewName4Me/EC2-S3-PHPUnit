<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./public/css/comun.css">
    <link rel="stylesheet" href="./public/css/index.css">
    <title>Our Wall</title>
</head>

<body>
    <h2><?php echo $_SESSION["mensajeDeError"] ?? '' ?></h2>
    <main>
        <section>
            <h2>Login</h2>
            <form action="./controller/loginController.php" method="POST">
                <label for="userName">Username:</label>
                <input type="text" name="userName" id="userName" placeholder="username">
                <label for="userPassword">Password:</label>
                <input type="password" name="userPassword" id="userPassword" placeholder="password">
                <input type="submit" name="login" id="login" value="Log in">
            </form>

        </section>
        <div></div>
        <section>
            <h2>Register</h2>
            <form action="./controller/registerController.php" method="POST">
                <label for="userName">Username:</label>
                <input type="text" name="userName" id="userName" placeholder="username">
                <label for="userPassword">Password:</label>
                <input type="password" name="userPassword" id="userPassword" placeholder="password">
                <label for="userPasswordRepeat">Repeat password:</label>
                <input type="password" name="userPasswordRepeat" id="userPasswordRepeat" placeholder="repeat password">
                <input type="submit" name="register" id="register" value="Register">
            </form>
        </section>
    </main>

    <!-- <script>
        setTimeout(() => {
            window.location.reload();
        }, 1000);
    </script> -->
</body>

</html>
