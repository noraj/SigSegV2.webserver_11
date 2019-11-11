<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Flag page</title>
  </head>
  <body>
    <section class="section">
      <div class="container">
        <h1 class="title">Flag page</h1>
<?php
// Turn off all error reporting
error_reporting(0);
$content = 'sigsegv{so_y0u_ar3_r3a11y_s3eri0us_4bout_XXE_4nd_SSRF}';
?>
      <pre><code><?= $content ?></code></pre>
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
