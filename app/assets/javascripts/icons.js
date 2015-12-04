$(document).on('ready page:load', function() {
  var logo = document.getElementById("logo");
  var diary = document.getElementById("i_diary");
  var personal = document.getElementById("i_personal");
  var lab = document.getElementById("i_lab");
  var home = document.getElementById("i_home");
  var settings = document.getElementById("i_settings");
  var catalogue = document.getElementById("i_catalogue");
  
  var aZ = document.getElementById("i_aZ");
  var zA = document.getElementById("i_zA");
  var stars = document.getElementById("i_stars");
  var starsR = document.getElementById("i_starsR");
  var bubbles = document.getElementById("i_bubbles");
  var bubblesR = document.getElementById("i_bubblesR");
  var bottles = document.getElementById("i_bottles");
  var bottlesR = document.getElementById("i_bottlesR");
  var wrench = document.getElementById("i_wrench");
  var brush = document.getElementById("i_brush");
  var frame = document.getElementById("i_frame");
  var faq = document.getElementById("i_faq");
  var book = document.getElementById("i_book");
  var bigPlus = document.getElementById("i_bigPlus");
  var puls = document.getElementById("i_puls");
  var portrait = document.getElementById("i_portrait");
  var eWeek = document.getElementById("i_eWeek");
  var eMonth = document.getElementById("i_eMonth");
  var eYear = document.getElementById("i_eYear");
  var dWeek = document.getElementById("i_dWeek");
  var dMonth = document.getElementById("i_dMonth");
  var dYear = document.getElementById("i_dYear");
  var cup = document.getElementById("i_cup");
  var plant = document.getElementById("i_plant");
  var bigScroll = document.getElementById("i_bigScroll");
  var bell = document.getElementById("i_bell");
  var i101 = document.getElementById("i_101");
  var radio = document.getElementById("i_radio");

  var coll = document.getElementById("collectionList");
  var wish = document.getElementById("wishlistList");
  var give = document.getElementById("giveawayList");
  var scro = document.getElementById("i_scroll");

  logo.innerHTML = '<svg class="icon iNav option logo" viewBox="-1 -1 94 36"><path d="M46.8 33.1c-1.7-0.9-5.5-2.8-6.8-3.5-3.7-2.1-11.4-5.5-12.2-5.5l0 4.2c0 4 0 4.2-0.1 4.3-0.1 0.1-0.2 0.2-0.7 0.1-0.7-0.1-4.5-0.1-6.3 0.1-1.9 0-3.8 0.2-5.5-0.6l0-2.5c0-2.6-0.2-5.1-0.3-6.2-0.6-5.9-0.2-11.8-0.9-17.8-0.1-0.9 0-3.3 0.1-3.7 0.2-0.4 0.3-0.5 2.4-0.5 1.5 0 2 0 2.2 0.1 1.5 1.1 3 2 4.5 3.2 0.4 0.3 1.8 1.2 3.5 2.2 2.7 1.9 5.6 3.8 8.3 5.7 0.6 0.4 1 0.6 1.1 0.4 0.3-0.3 0.5-4 0.4-6.8-0.1-2.2-0.1-3.8 0.1-4.5 0.2-0.7 0-0.7 2.8-0.7 2.7-0.2 5.7 0.1 8.4-0.4 0.7-0.1 1.1-0.1 1.2 0.1 0 0.1 0.1 2 0.1 4.3 0.3 8.3 0 17.1 0 25.1l0 3.2c-0.2 0.2-0.4 0.4-0.6 0.4-0.1 0-0.8-0.3-1.6-0.7zm24.8 0c-0.1-0.1-0.1-0.9-0.1-11.7 0-6.3 0-11.8 0-12.1 0-0.3 0-2.1 0-3.9 0-3.5 0-3.9 0.3-4.1 0.6-0.3 6.9 0.1 8.7 0.6 4.3 1.6 7 4.1 9.1 7.3 1.8 2.6 2.4 4 2.8 6.1 0.2 1.3 0.2 3.1-0.1 4.1-0.4 1.5-1.2 2.9-2 4.2-1.4 2.4-2 3.2-3.9 5-3.2 3.1-7.5 4-11.1 4.3-0.7-0.1-3.1 0.6-3.6 0.2zm9.2-13.7c1.4-1.1 2.3-2.9 2.2-4.6 0.4-2.2-4.4-4.4-4.2-3.4 0.2 3.1-0.1 5.5 0.1 8.8 0.7 0 1.4-0.4 1.9-0.8zm-80.8 4.6c0.1-19.9 0.1-21.3 0.2-21.5 0.1-0.2 0.1-0.2 0.9-0.3 2.5 0 5.3-0.3 7.5-0.3 3.6-0.1 3.6-0.1 3.8 0.4 0.1 0.2 0.1 0.9 0 2.5-0.1 1.6-0.1 6-0.1 14.5v12.2c-0.2 0.4-0.4 0.7-0.8 1-0.7 0.4-1 0.4-3.8 0.4-2.1-0.3-5.8 0.4-7.4-0.2-0.4-0.2-0.4 0-0.4-8.6zm51.7 8c-0.1-0.4-0.3-2.6-0.4-6.5-0.1-4.2-0.2-6.9-0.3-8.4-0.2-2-0.3-3.4-0.5-6.9-0.2-4.8-0.3-8.2-0.3-8.5 0.1-0.4 0.3-0.5 2.5-0.5 2.1 0 4.5-0.4 6.4-0.2 2.4 0.3 5.1-0.1 7.2 0.5 1.5 0.4 3 1.3 3.5 2 0.8 1.3 1.2 3.2 1.1 5.5-0.1 3.1-0.6 4.8-1.8 6.5-1.6 2.3-2.2 3-3.3 3.6-1.1 0.6-1.7 0.8-4.5 1.1-0.5 0.1-1 0.2-1 0.2-0.1 0.1 0 1.9 0.2 9.1 0 1.2 0 2.1-0.5 3h-7.9c-0.2-0.2-0.3-0.4-0.4-0.6zm10.2-20.1c0.9-1 1.1-2.8 0.6-3.8-0.5-0.8-2.8-1.4-3.4-0.6 0 1.3 0 4.4 0.4 5.6 0.7 0.1 1.7-0.6 2.4-1.2z"/></svg>';
  
  diary.innerHTML     = '<svg class="icon iNav" viewBox="0 0 36 36"><path d="m11 2 0 5C11 10 7.5 10 7.5 7l0-5c0-2.6 3.5-2.6 3.5 0zm17.5 0 0 5C28.5 10 25 10 25 7l0-5c0-2.6 3.5-2.6 3.5 0zm-7.5 26 0-2 2 0 0-11-2 0 0-2 4 0 0 13 2 0 0 2zm-9-5c0 2 1 3.5 3 3.5 1.5 0 2.5-0.5 2.5-2.5 0-2.5-2-3-4-3l0-2c2 0 3.5-0.5 3.5-2 0-1.7-1-2.2-2.5-2.2-1 0-2 1-2 3l0 0.1-1.9 0c0-1.8 0.4-2.8 1-3.6 0.7-0.8 1.7-1.3 3-1.2 2.4 0 4.2 1.6 4.2 3.9 0 1.5-0.8 2.7-2.3 3.2 1.8 0.8 2.7 2 2.7 3.9 0 3.2-2.3 4.4-4.6 4.4C11.5 28 10 26 10 23ZM2 4l0 28 32 0 0-28-4.5 0 0 3c0 4-5.5 4-5.5 0l0-3-12 0 0 3c0 4-5.5 4-5.5 0l0-3zm2 7 28 0 0 19-28 0z"/></svg>';
  personal.innerHTML  = '<svg class="icon iNav" viewBox="0 0 36 36"><path d="m14 15.5h8c1 0 0.9 1.5 0 1.5h-8c-1 0-1-1.5 0-1.5zm4 3.5c1.9 0 3.5 1.6 3.5 3.5 0 1.9-1.6 3.5-3.5 3.5s-3.5-1.6-3.5-3.5c0-1.9 1.6-3.5 3.5-3.5zm-16-6c-1.1 0.1-2 1.5 0 3 2.6 2 7.8 5.2 8 6 0.3 0.8-2.3 7.7-3 11-0.2 1.1 1.2 1.4 2 1 2.9-1.6 8.2-6 9-6 0.8 0 6.1 4.3 9 6 1 0.6 2.2-0.1 2-1-0.6-3.2-3.3-10.2-3-11 0.2-0.8 5.3-4 8-6 2-1.5 1.4-2.9 0.5-3-3.5-0.5-10.8 0.5-11.5 0s-2.6-8-4-11c-0.5-1-1.5-1-2 0-1.4 2.9-3.3 10.5-4 11-0.6 0.5-7.7-0.3-11 0z"/></svg>';
  lab.innerHTML       = '<svg class="icon iNav" viewBox="0 0 36 36"><path d="m18.5 2c-1 0-1.5 0.5-1.5 1v11.5c0 1-1 1-1 0v-11.5c0-0.6-0.5-1-1.5-1s-2.5 0.5-2.5 1v12.5c0 1-1 1-1 0v-9c0-1-0.4-1-1-1-1.1 0-2 1-2 2v10.5c7 0 8 2.5 8 8l2 0c0-4.5 1.5-8 7.1-8l-0.1-11.5c0-1.1-0.9-2-2-2-0.6 0-1 0.5-1 1v9c0 1-1 1-1 0v-11c0-1-1-1.5-2.5-1.5zm6.5 17c-5 0-6 3.5-6 7h6l6-7c1.1-1.3 2-2 0.5-3.5-1-1-2.4-0.6-3.5 0.5zm-17 0v7h7c0-5.5-1.5-7-7-7zm0 8v7h7l1-3c0.2-0.5 0.8-0.5 1 0l1 3h9l-2-7z"/></svg>';
  home.innerHTML      = '<svg class="icon iNav" viewBox="0 0 36 36"><path d="m3 17c-2 2 0 4 2 2l13-13 13 13c1.9 1.9 3.7 0.3 2-2l-3-3v-8h-4v4l-8-8zm3 3 12-12 12 12v14h-8v-10h-8v10h-8z"/></svg>';
  settings.innerHTML  = '<svg class="icon iNav" viewBox="0 0 36 36"><path d="m18 13.5c2.5 0 4.5 2 4.5 4.5 0 2.5-2 4.5-4.5 4.5-2.5 0-4.5-2-4.5-4.5 0-2.5 2-4.5 4.5-4.5zm-10 4.5c0.1 5.5 4.6 10 10 10 5.5 0 10-4.6 10-10 0-5.4-4.5-10-10-10-5.4 0-10 4.6-10 10zm7.5-16c-1.1 0.2-0.5 3.2-1.5 3.5-1 0.3-2.3-2.5-3.3-2-1 0.5 0.5 3.2-0.4 3.9-0.9 0.6-3-1.6-3.7-0.9-0.8 0.8 1.5 2.9 0.9 3.7-0.6 0.9-3.3-0.6-3.8 0.4-0.5 1 2.3 2.3 2 3.3-0.3 1-3.4 0.5-3.5 1.5-0.2 1.1 3 1.5 3 2.6 0 1.1-3.1 1.5-3 2.5 0.2 1.1 3.2 0.5 3.5 1.5 0.3 1-2.5 2.3-2 3.3 0.5 1 3.2-0.5 3.9 0.4 0.6 0.9-1.6 3-0.8 3.8 0.8 0.8 2.9-1.5 3.7-0.8 0.9 0.6-0.6 3.3 0.4 3.8 0.9 0.5 2.3-2.3 3.3-2 1 0.3 0.5 3.4 1.5 3.5 1.1 0.2 1.4-3 2.5-3 1.1 0 1.5 3.2 2.6 3 1.1-0.2 0.5-3.2 1.5-3.5 1-0.3 2.3 2.5 3.3 2 1-0.5-0.5-3.2 0.4-3.8 0.9-0.6 3 1.6 3.8 0.9s-1.5-2.9-0.9-3.7 3.4 0.6 3.8-0.4c0.5-0.9-2.3-2.3-2-3.3 0.3-1 3.4-0.4 3.5-1.5 0.3-1-3-1.4-3-2.5 0-1.1 3.3-1.5 3.1-2.6-0.2-1.1-3.2-0.5-3.5-1.5-0.3-1 2.5-2.3 2-3.3-0.5-0.9-3.2 0.5-3.8-0.4-0.6-0.9 1.6-3 0.9-3.7-0.8-0.8-2.9 1.5-3.8 0.9-0.9-0.6 0.6-3.4-0.4-3.8-1-0.5-2.3 2.3-3.3 2-1-0.3-0.4-3.4-1.5-3.5-1.1-0.3-1.5 2.9-2.6 2.9-1.1 0-1.4-3.2-2.5-3zm2.5 5c6.2 0 11 4.9 11 11 0.1 6.1-4.8 10.9-11 11-6.1 0-11-4.9-11-11 0-6.1 4.9-10.9 11-11z"/></svg>';
  catalogue.innerHTML = '<svg class="icon iNav" viewBox="0 0 36 36"><path d="m4.5 4v7h-2.5v23h32v-23h-2.5v-7zm1.5 1.5h24v5.5h-1c-2 0-3 1-3 3v2c0 2-1 3-3 3h-10c-2 0-3-1-3-3v-2c0-2-1-3-3-3h-1z"/></svg>';
  
  if (aZ) { aZ.innerHTML               = '<svg class="icon iNav option"><path d="m13 2h-3.5l-7.5 32h4l1.5-7h7.5l1.5 7h17.5v-3.5h-10l10-25v-3.5h-13.5v3.5h9.5l-10 25h-0.5zm-1.5 7 3 14.5h-6.5l3-14.5z"/></svg>';}
  if (zA) { zA.innerHTML               = '<svg class="icon iNav option"><path d="m2.5 2v3.5h9.5l-10 25v3.5h18l1.5-7h7.5l1.5 7h4l-7.5-32h-3.5l-6.5 28.5h-11l10-25v-3.5zm23 7.05 2.9 14h-6.4l3-14h0.5z"/></svg>';}
  if (stars) { stars.innerHTML         = '<svg class="icon iNav option"><use xlink:href="#stars"/></svg>';}
  if (starsR) { starsR.innerHTML       = '<svg class="icon iNav option"><use xlink:href="#stars" transform="matrix(-1 0 0 1 36 0)"/></svg>';}
  if (bubbles) { bubbles.innerHTML     = '<svg class="icon iNav option"><use xlink:href="#bubbles"/></svg>';}
  if (bubblesR) { bubblesR.innerHTML   = '<svg class="icon iNav option"><use xlink:href="#bubbles" transform="matrix(-1 0 0 1 36 0)"/></svg>';}
  if (bottles) { bottles.innerHTML     = '<svg class="icon iNav option"><use xlink:href="#bottles"/></svg>';}
  if (bottlesR) { bottlesR.innerHTML   = '<svg class="icon iNav option"><use xlink:href="#bottles" transform="matrix(-1 0 0 1 36 0)"/></svg>';}
  if (wrench) { wrench.innerHTML       = '<svg class="icon iNav option"><path d="m18 5c-2 2-2 5-1 7l-14 14c-2 2-1 4 0 5l2 2c1 1 3 2 5 0l14-14c2 1 5 1 7-1s4-5 2-8l-3.5 3.5-5.5-1.5-1.5-5.5 3.5-3.5c-3-2-6 0-8 2zm-10.5 21.5c1.2 0 2 0.9 2 2s-0.8 2-2 2c-1.2 0-2-0.8-2-2s0.8-2 2-2z"/></svg>';}
  if (brush) { brush.innerHTML         = '<svg class="icon iNav option"><path d="m14.5 13.5c0 2.5-0.5 2.5-5.5 2.5-2 0-2 1-2 3v8c0 3 0 5-2 7h23c2-2 2-4 2-7v-8c0-2 0-3-2-3-4.5 0-5.5-0.3-5.5-2.5 0-2.5 0.5-4.5 0.5-7.5 0-2.5-1.5-4-4.5-4s-4.5 1.5-4.5 4c0 3 0.5 5 0.5 7.5zm4-8.5c1.2 0 2 0.8 2 2 0 1.2-0.8 2-2 2s-2-0.8-2-2c0-1.2 0.8-2 2-2zm10.5 15v3h-21v-3zm0 4v2h-21v-2z"/></svg>';}
  if (frame) { frame.innerHTML         = '<svg class="icon iNav option"><path d="m9 9v18h18v-18zm2 2h14v14h-14zm-9-9 0 31.9h32.2l-0.2-31.9zm4.2 4 23.8 0v24h-24z"/></svg>';}
  if (faq) { faq.innerHTML             = '<svg class="icon iNav option"><path d="m27 1.5c-4.5 0-7.5 2.5-7.5 7.5v3l-2.5-10h-15v32h3v-15h5.5l-3 15h3l1.5-7h8l1.5 7c2.5 0 4 0.5 5.5 0.5 1.8 0 3.2-0.5 4.2-1.3l2.3 2.3 2-2-2.5-2.5c0.7-1.4 1-3.2 1-5.2v-16.8c0-5-2.5-7.5-7-7.5zm0 3c3 0 4 1.5 4 4.5 0.1 6.6 0 11 0 17 0 1-0.1 1.9-0.4 2.7l-1.6-1.7-2 2 2 2c-0.5 0.3-1.2 0.5-2 0.5-3 0-4-2.5-4-5.5v-17c0-3 1-4.5 4-4.5zm-22 0.5h8.5l-2.5 11h-6zm10.5 3 4 16h-7z"/></svg>';}
  if (book) { book.innerHTML           = '<svg class="icon iNav option"><path d="m4 31c0 1.5 0.5 3 2 3h24c1 0 1-1.5 0-1.5h-24c-0.8 0-0.9-2.5 0-2.5h23c2 0 3-1 3-3v-22c0-2-1-3-3-3h-22c-3 0-3 1-3 4zm5-28h6v26l-6-0.1z"/></svg>';}
  if (bigPlus) { bigPlus.innerHTML     = '<svg class="icon iNav option"><path d="m16 6v10h-10v4h10v10h4v-10l10-0.1v-3.9h-10v-10z"/></svg>';}
  if (puls) { puls.innerHTML           = '<svg class="icon iNav option"><path d="m8 18h3c0.2 1 0.5 2 1 2 0.7 0 0.4-5 2-5 1.5 0 1.5 6 2.5 6 1.6 0 1.5-13 4.5-13s2 18 3 18c0.8 0 0-10 2-10 1 0 1 2 2 2s1 0 1 0.5 0 0.5-1 0.5c-2 0-1.5-2-2-2s0.5 10-2 10c-3 0-2-18-3-18-2 0-1 13-4.5 13-1.9 0-1.5-6-2.5-6-0.7 0-1 5-2 5s-1-1-1.5-2h-2.5c-1 0-1-1 0-1zm-6-16v32h32v-32zm8 4h16c3 0 4 1 4 4v16c0 3-1 4-4 4h-16c-2.4 0-3.8-1-3.8-4v-16c0-3 0.8-4 3.8-4z"/></svg>';}
  if (portrait) { portrait.innerHTML   = '<svg class="icon iNav option"><path d="m2 2v32h32v-32zm4 4h24v24h-24zm3 3v18h18v-18zm16.5 1.5v15h-1c0-0.9 0.3-3.4-2.5-4.5-1 0.9-2.5 2-4 2s-3-1.1-4-2c-2.6 1.2-2.5 3.7-2.5 4.5h-1v-15zm-7.5 1.5c-2.3 0-4.5 1.4-4.5 4s2.2 5 4.5 5c2.4 0 4.5-2.4 4.5-5s-2.1-4-4.5-4z"/></svg>';}
  if (eWeek) { eWeek.innerHTML         = '<svg class="icon iNav option"><path d="m4 2h10c1.1 0 2 0.9 2 2v10c0 1.1-0.9 2-2 2h-10c-1.1 0-2-0.9-2-2v-10c0-1.1 0.9-2 2-2zm18 0h10c1.1 0 2 0.9 2 2v10c0 1.1-0.9 2-2 2h-10c-1.1 0-2-0.9-2-2v-10c0-1.1 0.9-2 2-2zm-18 18h10c1.1 0 2 0.9 2 2v10c0 1.1-0.9 2-2 2h-10c-1.1 0-2-0.9-2-2v-10c0-1.1 0.9-2 2-2zm18 0h10c1.1 0 2 0.9 2 2v10c0 1.1-0.9 2-2 2h-10c-1.1 0-2-0.9-2-2v-10c0-1.1 0.9-2 2-2z"/></svg>';}
  if (eMonth) { eMonth.innerHTML       = '<svg class="icon iNav option"><path d="m4 2.1h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.6 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.4 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm-23 11.5h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.6 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.4 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm-23 11.4h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.6 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.4 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2z"/></svg>';}
  if (eYear) { eYear.innerHTML         = '<svg class="icon iNav option"><path d="m20 10.5h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.5 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-8.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-25.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 8.5h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-8.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-25.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 8.5h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-8.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-25.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17-25.5h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.4-1 1-1zm-8.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-25.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1z"/></svg>';}
  if (dWeek) { dWeek.innerHTML         = '<svg class="icon iNav option"><path d="m30.3 14.8v-8.7l-1.7 1.2v-3l2-1.5h2.8v12zm-5.8-3.7c0.1-1.1 0-1.3-1-1.3h-0.9v-2.2h1c0.7 0 0.9-0.5 0.9-1 0.1-1-0.4-1-0.6-1-0.5 0-0.6 0.4-0.8 1l-2.9-0.4c0.1-2.2 1.8-3.3 3.8-3.4 2.4 0 3.7 1.5 3.6 3.5 0 1-0.5 2-1.3 2.3 0.7 0.5 1.2 1.1 1.3 1.9 0 0.8 0 1.6-0.2 2.2-0.5 1.8-2 2.2-3.6 2.3-2.3 0.1-3.4-1.3-3.8-3.3l3-0.4c0 0.6 0.2 1.1 0.7 1.1 0.8 0 0.7-0.6 0.8-1.2zm-16.6 10.9-2 1.5v3l1.6-1.1v6.1c0 1.2-0.6 1-1.6 1.1v1.5h6.5v-1.5c-1.1-0.2-1.4-0.2-1.5-1.2v-9.4zm14.1-2h10c1.1 0 2 0.9 2 2v10c0 1.1-0.9 2-2 2h-10c-1.1 0-2-0.9-2-2v-10c0-1.1 0.9-2 2-2zm-18-18h10c1.1 0 2 0.9 2 2v10c0 1.1-0.9 2-2 2h-10c-1.1 0-2-0.9-2-2v-10c0-1.1 0.9-2 2-2z"/></svg>';}
  if (dMonth) { dMonth.innerHTML       = '<svg class="icon iNav option"><path d="m4 2h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm0 11.5h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.5 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.5 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm-11.5 11.5h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm11.5 0h5c1.1 0 2 0.9 2 2v5c0 1.1-0.9 2-2 2h-5c-1.1 0-2-0.9-2-2v-5c0-1.1 0.9-2 2-2zm-11.4-15.8c-0.2 0-0.4-0.2-0.5-0.8l-2.3 0.3c0.1 1.7 1.1 2.5 2.9 2.5 1.8 0 2.8-0.4 2.8-2.7 0-1.5-0.5-2-0.9-2.1l2.2-1.9v6.6h2.3v-9h-2l-1.8 1.3c-0.3-0.7-1-1.3-2.4-1.3-1.5 0-2.7 0.8-2.9 2.5l2.2 0.3c0.1-0.4 0-0.9 0.6-0.9 0.3 0 0.5 0.2 0.5 0.6 0 0.9-0.1 1.1-1.4 1.1v1.7c1.8 0 1.4 0.2 1.4 1.1 0 0.5-0.1 0.8-0.5 0.8zm-9.1 24.8c-2.3 0-3.3-0.9-3.4-2.5l2.8-0.3c0 0.6 0.3 0.8 0.7 0.8 0.5 0 0.7-0.4 0.7-1.2 0-1-0.3-1.3-0.7-1.3-0.6 0-0.5 0.4-0.6 0.6l-2.4-0.1v-5h6v2h-3.3l0 1c0.4-0.2 0.7-0.2 1.1-0.2 2.2 0 2.7 0.7 2.7 3.2s-1.5 3-3.5 3zm22.8-32-1.5 1.1v2.2l1.2-0.8v4.2c0 0.9-0.4 0.7-1.2 0.8v1.4h4.8v-1.4c-0.8 0-1.1 0-1.2-0.8v-6.7z"/></svg>';}
  if (dYear) { dYear.innerHTML         = '<svg class="icon iNav option"><path d="m11.5 10.5h4.5c0.5 0 1 0.5 1 1v4.5c0 0.6-0.5 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-25.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 8.5h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-8.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-8.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 8.5h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-8.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm17 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm0-25.5h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm-25.5 0h4.5c0.6 0 1 0.5 1 1v4.5c0 0.6-0.4 1-1 1h-4.5c-0.6 0-1-0.4-1-1v-4.5c0-0.6 0.5-1 1-1zm25.2 23.1v-4.1l-0.8 0.7v-1.7l1-0.8h1.4v6zm3.9-1.5c0.2 0 0.3-0.1 0.3-1.5 0-1.4-0.1-1.5-0.3-1.6-0.3 0-0.4 0.3-0.4 1.6 0 1.3 0.1 1.6 0.4 1.5zm0 1.5c-1.2 0-2.1-0.4-2.1-3s0.9-3.1 2.1-3.1c1.4 0 2.1 0.7 2.1 3.1s-0.9 3-2.1 3.1zm-30.1 8.9v-6.4h1.7v6.4zm6.3-3.5v1h0.5v1.6h-0.4v1h-1.5v-1h-2.8v-1.3l1.8-4h1.9l-1.7 3.7h0.8v-0.9zm4.4-22.2c-1.4 0-2.2-0.6-2.2-1.8l1.7-0.2c0 0.7 0.8 0.7 0.8 0 0-0.8-0.4-0.7-1.1-0.7v-1.2c0.9 0.1 1.1-0.4 1.1-0.7 0-0.7-0.8-0.7-0.8 0.2l-1.7-0.3c0.2-1.2 1.1-1.8 2.2-1.8 1 0 1.6 0.4 2 1.3l1.1-1.1h1.2v6.3h-1.5v-4.6l-1.3 1.3c0.5 0.2 0.7 0.5 0.7 1.1 0 1.8-0.8 2.2-2.2 2.2zm9.6 8.7c-1.7 0-2.4-0.7-2.5-1.8l2-0.2c0 0.4 0.2 0.6 0.5 0.6 0.4 0 0.4-0.3 0.4-0.9 0-0.7-0.2-0.8-0.4-0.8-0.4 0-0.4 0.2-0.5 0.4h-1.8v-3.7h4.6v1.3h-2.6v0.8c0.3-0.1 0.5-0.1 0.8-0.1 1.6 0 2 0.5 2 2.3 0 1.8-1.2 2.2-2.6 2.2zm-0.8-15.1-1.3 0.8v1.6l1-0.6v3.1c0 0.6-0.4 0.5-1 0.6v1h4.2v-1c-0.8-0.1-1-0.1-1.1-0.6v-4.9z"/></svg>';}
  if (cup) { cup.innerHTML             = '<svg class="icon iNav option"><path d="m7 2v3h22v-3zm-5 4c0 7 0 15 9 17 1.3 2.1 2.8 3.8 5 5v3c0 2-3 0-3 3h10c0-3-3-1-3-3v-3c2.2-1.2 3.7-2.9 5-5 9-2 9-10 9-17zm2 2h3c0.2 4.3 1.3 9.2 3 13-6-2-6-8-6-13zm25 0h3c0 4.5 0 11-6 13 1.7-3.8 2.8-8.7 3-13z"/></svg>';}
  if (plant) { plant.innerHTML         = '<svg class="icon iNav option"><path d="m22 4c-4 2-5 4-5 8v4c-1-4-2.5-5-5-7-3.9-3.1-7-3-10-2 0 4 1 7 5 10 2.1 1.5 7 2 10 0v4h-11c-2 0-2 3 0 3h24c2 0 2-3 0-3h-11v-8c3 0.6 7 1 10-2s4-6 5-9c-5 0-8 0-12 2zm-14 21 2 9h16l2-9z"/></svg>';}
  if (bigScroll) { bigScroll.innerHTML = '<svg class="icon iNav option"><path d="m4 27h16c0.1 2.6 0 3 1 4h-15c-2 0-2-1-2-4zm28-18-4 0c0-3.1 0.5-4 2-4 1.5 0 2 1 2 4zm-21-6c-2.2 0-4 1.8-4 4v18h-5v4c0 2.2 1.8 4 4 4h18c3 0 4-2 4-4v-18l6 0.1v-4c0-2.1-1.6-4-4-4z"/></svg>';}
  if (bell) { bell.innerHTML           = '<svg class="icon iNav option"><path d="m17 4c-1 0-2 1-2 2v1c-4.9 1.3-7 5.7-7 9 0 5-0.9 10.4-6 16v2h12.5c0.7 1.3 2 2 3.5 2 1.5 0 2.8-0.7 3.5-2h12.5v-2c-5.1-5.6-6-11.1-6-16 0-3.3-2.2-7.7-7-9v-1c0-1.1-0.9-2-2-2zm0 2h2v1h-2z"/></svg>';}
  if (i101) { i101.innerHTML           = '<svg class="icon iNav option"><path d="m4 31c0 2 0.5 3 2 3h24c1.5 0 1.5-1.5 0-1.5h-24c-0.8 0-0.8-2.4 0-2.4h23c2 0 3-1 3-3v-22c0-2-1-3-3-3h-21c-3 0-4 1-4 4zm14.5-23.2c0.8 0 1.4 0.3 1.8 0.8 0.4 0.5 0.6 1.4 0.6 2.4s-0.2 1.8-0.6 2.3c-0.4 0.5-1 0.8-1.8 0.8-0.8 0-1.4-0.3-1.8-0.8-0.4-0.5-0.6-1.3-0.6-2.3s0.2-1.8 0.6-2.4c0.4-0.5 1-0.8 1.8-0.8zm-5.7 0.2h1.4v5h1.3v1h-4v-1h1.3v-4l-1.4 0.3v-0.7zm10.3 0h1.4v5h1.3v1h-4.1v-1h1.3v-4l-1.3 0.2v-0.7zm-4.6 0.9c-1 0-0.9 1.3-0.9 2.1 0 1-0.1 2.1 0.9 2.1s0.9-1.2 0.9-2.1c0-1.1 0.1-2.1-0.9-2.1z"/></svg>';}
  if (radio) { radio.innerHTML         = '<svg class="icon iNav option"><path d="m23 6c1 2 1 5 0 6.5l-2-1.5c0.5-0.5 0.5-2.5 0-3.5zm4-2c2 3 2 7 0 10.5l-2-1.5c1.5-2.5 1.5-5.5 0-7.5zm4-2c3 4.5 3 10 0 14.5l-2-1.5c2.5-3.5 2.5-8 0-11.5zm-9 24.5 0.5 1.5h-9l0.5-1.5zm-1.5-5.5 0.5 1.5h-6l0.5-1.5zm-2.5-7 1 3h-2zm-2-6-8.5 25.5 4.5 0.5l0.5-2h11l0.5 2 4.5-0.5-8.5-25.5c-0.7-2-3.3-2-4 0zm-3-2c-1 2-1 5 0 6.5l2-1.5c-0.5-0.5-0.5-2.5 0-3.5zm-4-2c-2 3-2 7 0 10.5l2-1.5c-1.5-2.5-1.5-5.5 0-7.5zm-4-2c-3 4.5-3 10 0 14.5l2-1.5c-2.5-3.5-2.5-8 0-11.5zm25.9 14.8c-19.3 11.4-9.6 5.7 0 0z"/></svg>';}

  if (coll) { coll.innerHTML = '<svg class="icon iPolish hoverBack"><path d="m5 2h21v5h-21zm1.03 6v14.8h19.04v-14.8zm6.05 3h6.96v3.1h-6.96z"/></svg>';}
  if (wish) { wish.innerHTML = '<svg class="icon iPolish wishlist hoverBack"><path d="m17.5 4c-1 0-1.5 0.5-1.5 1.5s1 1.2 1 1.5c-1.5 0.2-2.7 1.7-3 3-1.4 0-3 0-3 1-2 0-2.6-2-8.8-2h-2c0 0.4 0.8 1.5 1.7 1.6 4.6 0.2 5 4.5 9.2 7.8 1.2 0.9 3 1.4 4.7 1.6-0.5 1-2 1.5-4 1.5-1 0-1 1.5-1 1.5h13s0-1.5-1-1.5c-1.5 0-3.5-0.5-4-1.5 2.4-0.1 5.4-1.8 6-4 1 0 1.1-0.6 1.1-1 0-1 1.2-1.5 1.9-2 1.1-0.8 3-2.5 3-5 0-2.7-2-4.5-4-4.5-3-0-4 1.5-4 3s1 2.5 2 2.5 2-0.5 2-2c-0-0.5-0-1-1-1.5 0 0 0-0.5 1.5-0.5 1 0 2 1 2 2.5 0 2.5-4 2.7-5.5 3.5-0.1-0.9-1.6-0.9-3-1-0.2-1.3-1.6-2.8-3-3 0-0.3 1-0.5 1-1.5s-0.5-1.5-1.5-1.5z"/></svg>';}
  if (give) { give.innerHTML = '<svg class="icon iPolish hoverBack"><path d="m22 2c-3 0-3.86 1.8-5.04 3.1-0.13-0.7-0.79-1.1-1.46-1.1-0.65 0-1.3 0.3-1.47 1-1.84-1.8-2.03-3-5.03-3-1.36 0-3 1-3 2.5s0.79 2.2 2 2.5h-3v4.1h8v-4.1h5v4h8v-4h-3.15c1.21-0.3 2.15-1 2.15-2.5 0-1.9-1-2.5-3-2.5zm-16 10v11h19v-11h-7v7.3l-2.5-2.3-2.5 2.3v-7.3z"/></svg>';}
  if (scro) { scro.innerHTML = '<svg class="icon iPolish linkLike switch hoverBack"><path d="m5.5 19h12v1.5c0 0.6 0.2 1.1 0.4 1.5h-10.8c-0.9 0-1.5-0.8-1.5-1.5zm21-13.5v1.5h-3.5v-1.5c0-1 0.7-1.5 1.7-1.5 1 0 1.8 0.5 1.8 1.5zm-15.6-3.1c-1.7 0-3 1.5-3 3.1v12h-2.5-1.5v3.1c0 1.6 1.3 2.9 3 2.9h13.5c1.6 0 2.4-1.3 2.5-3v-12h5v-3c0-1.6-1.3-3.1-3.2-3.1z"/></svg>';}
  
});