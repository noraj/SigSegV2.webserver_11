<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!--<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.8.0/css/bulma.min.css">-->
    <link rel="stylesheet" href="css/bulma.min.css">
    <!--<script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>-->
    <script defer src="js/fa.js"></script>
    <title>Image checker</title>
  </head>
  <body>
    <section class="section">
      <div class="container">
        <h1 class="title">Image checker</h1>
<?php
// Turn off all error reporting
error_reporting(0);
?>
        <form action="view.php" method="get">
          <div class="field">
            <label class="label">SVG file</label>
            <div class="control has-icons-left">
              <input class="input" name="svg" type="text" placeholder="https://upload.wikimedia.org/wikipedia/commons/6/6a/Godot_icon.svg">
              <span class="icon is-small is-left">
                <i class="fas fa-image"></i>
              </span>
            </div>
          </div>
          <div class="control">
            <button class="button is-primary">Submit</button>
          </div>
        </form>
      </div>
    </section>
    <footer class="footer">
      <div class="content has-text-centered">
        <p> 
          Made with
          <span class="icon has-text-danger"><i class="fas fa-heart"></i></span>
          by
          <span class="has-text-weight-semibold">
            <a class="has-text-primary" href="https://pwn.by/noraj/">noraj</a>
          </span>
        </p>
      </div>
    </footer>
  </body>
</html>