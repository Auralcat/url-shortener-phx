import * as validUrl from 'valid-url';

window.validUrl = validUrl;
window.checkUrl = function checkUrl(urlInput) {
  let string = urlInput.value;

  if (string === "") {
    // Do nothing on blank string
    return urlInput;
  } else if (!~string.indexOf("http")) {
    string = "http://" + string;
  }

  urlInput.value = string;
  return urlInput;
};

window.validateUrlFormat = function validateUrlFormat(urlInput) {
  let string = urlInput.value;
  console.log( validUrl.isWebUri(string) );

  if (validUrl.isWebUri(string)) {
    return urlInput;
  } else {
    return false;
  }
};
