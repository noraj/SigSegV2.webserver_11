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

if (array_key_exists('svg', $_GET)) {
  // the file provided by the user
  $file = $_GET['svg'];
  // verify MIME type and extension
  $allowed_formats = ["image/svg+xml" => "svg"];
    // make a req to the remote resource
  $ch = curl_init($file);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
  curl_setopt($ch, CURLOPT_HEADER, TRUE);
  curl_setopt($ch, CURLOPT_NOBODY, TRUE);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, TRUE);
  curl_exec($ch);
    // get the MIME type as given by the remote server
    // we are trusting teh remote server to avoid downloading the file
  $mime = curl_getinfo($ch, CURLINFO_CONTENT_TYPE);
    // get extension
  $path = parse_url($file, PHP_URL_PATH);
  $extension = pathinfo($path, PATHINFO_EXTENSION);
  if ([$mime => $extension] !== $allowed_formats) {
    exit('Unauthorized file type!');
  }
  // Seems to work only for octet stream
  $size = curl_getinfo($ch, CURLINFO_CONTENT_LENGTH_DOWNLOAD);
  if ($size == -1) {
    $size = 'unknown';
  }
} else {
  // https://upload.wikimedia.org/wikipedia/commons/6/6a/Godot_icon.svg
  $file = 'img/Godot_icon.svg';
  $mime = mime_content_type($file);
  $extension = pathinfo($file, PATHINFO_EXTENSION);
  $size = filesize($file);
}

$xmlfile = file_get_contents($file);
$dom = new DOMDocument();
$dom->loadXML($xmlfile, LIBXML_NOENT | LIBXML_DTDLOAD);
$svg = simplexml_import_dom($dom);
$attrs = $svg->attributes();
$width = (int) $attrs->width;
$height = (int) $attrs->height;
?>
        <figure class="image is-128x128">
          <img class="is-rounded" src="<?= $file ?>">
        </figure>
        <p>
          <span class="has-text-primary has-text-weight-bold">Size:</span>
          <?= $width ?> x <?= $height ?>
        </p>
        <p>
          <span class="has-text-primary has-text-weight-bold">URL:</span>
          <?= $file ?>
        </p>
        <p>
          <span class="has-text-primary has-text-weight-bold">MIME-type:</span>
          <?= $mime ?>
        </p>
        <p>
          <span class="has-text-primary has-text-weight-bold">Extension:</span>
          <?= $extension ?>
        </p>
        <p>
          <span class="has-text-primary has-text-weight-bold">Size:</span>
          <?= $size ?> bytes
        </p>
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