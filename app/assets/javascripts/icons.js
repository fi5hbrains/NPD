$(document).on('ready page:load', function() {
  var logo = document.getElementById("logo");
  var diary = document.getElementById("i_diary");
  var personal = document.getElementById("i_personal");
  var lab = document.getElementById("i_lab");
  var home = document.getElementById("i_home");
  var settings = document.getElementById("i_settings");
  var catalogue = document.getElementById("i_catalogue");

  logo.innerHTML = '<svg class="icon iNav option logo" viewBox="-1 -1 94 36"><path d="M46.8 33.1c-1.7-0.9-5.5-2.8-6.8-3.5-3.7-2.1-11.4-5.5-12.2-5.5l0 4.2c0 4 0 4.2-0.1 4.3-0.1 0.1-0.2 0.2-0.7 0.1-0.7-0.1-4.5-0.1-6.3 0.1-1.9 0-3.8 0.2-5.5-0.6l0-2.5c0-2.6-0.2-5.1-0.3-6.2-0.6-5.9-0.2-11.8-0.9-17.8-0.1-0.9 0-3.3 0.1-3.7 0.2-0.4 0.3-0.5 2.4-0.5 1.5 0 2 0 2.2 0.1 1.5 1.1 3 2 4.5 3.2 0.4 0.3 1.8 1.2 3.5 2.2 2.7 1.9 5.6 3.8 8.3 5.7 0.6 0.4 1 0.6 1.1 0.4 0.3-0.3 0.5-4 0.4-6.8-0.1-2.2-0.1-3.8 0.1-4.5 0.2-0.7 0-0.7 2.8-0.7 2.7-0.2 5.7 0.1 8.4-0.4 0.7-0.1 1.1-0.1 1.2 0.1 0 0.1 0.1 2 0.1 4.3 0.3 8.3 0 17.1 0 25.1l0 3.2c-0.2 0.2-0.4 0.4-0.6 0.4-0.1 0-0.8-0.3-1.6-0.7zm24.8 0c-0.1-0.1-0.1-0.9-0.1-11.7 0-6.3 0-11.8 0-12.1 0-0.3 0-2.1 0-3.9 0-3.5 0-3.9 0.3-4.1 0.6-0.3 6.9 0.1 8.7 0.6 4.3 1.6 7 4.1 9.1 7.3 1.8 2.6 2.4 4 2.8 6.1 0.2 1.3 0.2 3.1-0.1 4.1-0.4 1.5-1.2 2.9-2 4.2-1.4 2.4-2 3.2-3.9 5-3.2 3.1-7.5 4-11.1 4.3-0.7-0.1-3.1 0.6-3.6 0.2zm9.2-13.7c1.4-1.1 2.3-2.9 2.2-4.6 0.4-2.2-4.4-4.4-4.2-3.4 0.2 3.1-0.1 5.5 0.1 8.8 0.7 0 1.4-0.4 1.9-0.8zm-80.8 4.6c0.1-19.9 0.1-21.3 0.2-21.5 0.1-0.2 0.1-0.2 0.9-0.3 2.5 0 5.3-0.3 7.5-0.3 3.6-0.1 3.6-0.1 3.8 0.4 0.1 0.2 0.1 0.9 0 2.5-0.1 1.6-0.1 6-0.1 14.5v12.2c-0.2 0.4-0.4 0.7-0.8 1-0.7 0.4-1 0.4-3.8 0.4-2.1-0.3-5.8 0.4-7.4-0.2-0.4-0.2-0.4 0-0.4-8.6zm51.7 8c-0.1-0.4-0.3-2.6-0.4-6.5-0.1-4.2-0.2-6.9-0.3-8.4-0.2-2-0.3-3.4-0.5-6.9-0.2-4.8-0.3-8.2-0.3-8.5 0.1-0.4 0.3-0.5 2.5-0.5 2.1 0 4.5-0.4 6.4-0.2 2.4 0.3 5.1-0.1 7.2 0.5 1.5 0.4 3 1.3 3.5 2 0.8 1.3 1.2 3.2 1.1 5.5-0.1 3.1-0.6 4.8-1.8 6.5-1.6 2.3-2.2 3-3.3 3.6-1.1 0.6-1.7 0.8-4.5 1.1-0.5 0.1-1 0.2-1 0.2-0.1 0.1 0 1.9 0.2 9.1 0 1.2 0 2.1-0.5 3h-7.9c-0.2-0.2-0.3-0.4-0.4-0.6zm10.2-20.1c0.9-1 1.1-2.8 0.6-3.8-0.5-0.8-2.8-1.4-3.4-0.6 0 1.3 0 4.4 0.4 5.6 0.7 0.1 1.7-0.6 2.4-1.2z"/></svg>';
  diary.innerHTML = '<path d="m11 2 0 5C11 10 7.5 10 7.5 7l0-5c0-2.6 3.5-2.6 3.5 0zm17.5 0 0 5C28.5 10 25 10 25 7l0-5c0-2.6 3.5-2.6 3.5 0zm-7.5 26 0-2 2 0 0-11-2 0 0-2 4 0 0 13 2 0 0 2zm-9-5c0 2 1 3.5 3 3.5 1.5 0 2.5-0.5 2.5-2.5 0-2.5-2-3-4-3l0-2c2 0 3.5-0.5 3.5-2 0-1.7-1-2.2-2.5-2.2-1 0-2 1-2 3l0 0.1-1.9 0c0-1.8 0.4-2.8 1-3.6 0.7-0.8 1.7-1.3 3-1.2 2.4 0 4.2 1.6 4.2 3.9 0 1.5-0.8 2.7-2.3 3.2 1.8 0.8 2.7 2 2.7 3.9 0 3.2-2.3 4.4-4.6 4.4C11.5 28 10 26 10 23ZM2 4l0 28 32 0 0-28-4.5 0 0 3c0 4-5.5 4-5.5 0l0-3-12 0 0 3c0 4-5.5 4-5.5 0l0-3zm2 7 28 0 0 19-28 0z"/>';
  personal.innerHTML = '<path d="m14 15.5h8c1 0 0.9 1.5 0 1.5h-8c-1 0-1-1.5 0-1.5zm4 3.5c1.9 0 3.5 1.6 3.5 3.5 0 1.9-1.6 3.5-3.5 3.5s-3.5-1.6-3.5-3.5c0-1.9 1.6-3.5 3.5-3.5zm-16-6c-1.1 0.1-2 1.5 0 3 2.6 2 7.8 5.2 8 6 0.3 0.8-2.3 7.7-3 11-0.2 1.1 1.2 1.4 2 1 2.9-1.6 8.2-6 9-6 0.8 0 6.1 4.3 9 6 1 0.6 2.2-0.1 2-1-0.6-3.2-3.3-10.2-3-11 0.2-0.8 5.3-4 8-6 2-1.5 1.4-2.9 0.5-3-3.5-0.5-10.8 0.5-11.5 0s-2.6-8-4-11c-0.5-1-1.5-1-2 0-1.4 2.9-3.3 10.5-4 11-0.6 0.5-7.7-0.3-11 0z"/>';
  lab.innerHTML = '<path d="m18.5 2c-1 0-1.5 0.5-1.5 1v11.5c0 1-1 1-1 0v-11.5c0-0.6-0.5-1-1.5-1s-2.5 0.5-2.5 1v12.5c0 1-1 1-1 0v-9c0-1-0.4-1-1-1-1.1 0-2 1-2 2v10.5c7 0 8 2.5 8 8l2 0c0-4.5 1.5-8 7.1-8l-0.1-11.5c0-1.1-0.9-2-2-2-0.6 0-1 0.5-1 1v9c0 1-1 1-1 0v-11c0-1-1-1.5-2.5-1.5zm6.5 17c-5 0-6 3.5-6 7h6l6-7c1.1-1.3 2-2 0.5-3.5-1-1-2.4-0.6-3.5 0.5zm-17 0v7h7c0-5.5-1.5-7-7-7zm0 8v7h7l1-3c0.2-0.5 0.8-0.5 1 0l1 3h9l-2-7z"/>';
  home.innerHTML = '<path d="m3 17c-2 2 0 4 2 2l13-13 13 13c1.9 1.9 3.7 0.3 2-2l-3-3v-8h-4v4l-8-8zm3 3 12-12 12 12v14h-8v-10h-8v10h-8z"/>';
  settings.innerHTML = '<path d="m18 13.5c2.5 0 4.5 2 4.5 4.5 0 2.5-2 4.5-4.5 4.5-2.5 0-4.5-2-4.5-4.5 0-2.5 2-4.5 4.5-4.5zm-10 4.5c0.1 5.5 4.6 10 10 10 5.5 0 10-4.6 10-10 0-5.4-4.5-10-10-10-5.4 0-10 4.6-10 10zm7.5-16c-1.1 0.2-0.5 3.2-1.5 3.5-1 0.3-2.3-2.5-3.3-2-1 0.5 0.5 3.2-0.4 3.9-0.9 0.6-3-1.6-3.7-0.9-0.8 0.8 1.5 2.9 0.9 3.7-0.6 0.9-3.3-0.6-3.8 0.4-0.5 1 2.3 2.3 2 3.3-0.3 1-3.4 0.5-3.5 1.5-0.2 1.1 3 1.5 3 2.6 0 1.1-3.1 1.5-3 2.5 0.2 1.1 3.2 0.5 3.5 1.5 0.3 1-2.5 2.3-2 3.3 0.5 1 3.2-0.5 3.9 0.4 0.6 0.9-1.6 3-0.8 3.8 0.8 0.8 2.9-1.5 3.7-0.8 0.9 0.6-0.6 3.3 0.4 3.8 0.9 0.5 2.3-2.3 3.3-2 1 0.3 0.5 3.4 1.5 3.5 1.1 0.2 1.4-3 2.5-3 1.1 0 1.5 3.2 2.6 3 1.1-0.2 0.5-3.2 1.5-3.5 1-0.3 2.3 2.5 3.3 2 1-0.5-0.5-3.2 0.4-3.8 0.9-0.6 3 1.6 3.8 0.9s-1.5-2.9-0.9-3.7 3.4 0.6 3.8-0.4c0.5-0.9-2.3-2.3-2-3.3 0.3-1 3.4-0.4 3.5-1.5 0.3-1-3-1.4-3-2.5 0-1.1 3.3-1.5 3.1-2.6-0.2-1.1-3.2-0.5-3.5-1.5-0.3-1 2.5-2.3 2-3.3-0.5-0.9-3.2 0.5-3.8-0.4-0.6-0.9 1.6-3 0.9-3.7-0.8-0.8-2.9 1.5-3.8 0.9-0.9-0.6 0.6-3.4-0.4-3.8-1-0.5-2.3 2.3-3.3 2-1-0.3-0.4-3.4-1.5-3.5-1.1-0.3-1.5 2.9-2.6 2.9-1.1 0-1.4-3.2-2.5-3zm2.5 5c6.2 0 11 4.9 11 11 0.1 6.1-4.8 10.9-11 11-6.1 0-11-4.9-11-11 0-6.1 4.9-10.9 11-11z"/>';
  catalogue.innerHTML = '<path d="m4.5 4v7h-2.5v23h32v-23h-2.5v-7zm1.5 1.5h24v5.5h-1c-2 0-3 1-3 3v2c0 2-1 3-3 3h-10c-2 0-3-1-3-3v-2c0-2-1-3-3-3h-1z"/>';
});


