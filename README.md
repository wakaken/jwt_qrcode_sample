# JWT-QR code sample
This repository contains the sample sources to process JWT through QR Code.

# Why JWT?
To make use of the JWT's features as below.

- Forgery detection using public key encryption.
- Expiration check.

## Requirement
- Ruby 2.2 or higher
- Rails 5.0 or higher
- JWT and RQRCode gems. See the following links.

  https://github.com/jwt/ruby-jwt
  
  https://github.com/whomwah/rqrcode
  
- PostgreSQL

## Install & Start Rails
- Clone this repository

  git clone https://github.com/wakaken/jwt_qrcode_sample.git

- Install gems

  bundle install

- Set environment variables for database accordingly.

  export JWT_QRCODE_SAMPLE_DATABASE_USERNAME=username 

  export JWT_QRCODE_SAMPLE_DATABASE_PASSWORD=password

  The default database is PostgreSQL and the default schema is "public".
  If you'd like to change database, please change the configuration of database.yml

- Create DB

  rails db:create

- Migrate DB

  rails db:migrate

- Start Rails

  rails s
  
## Prerequisites of the sample sources.
- No parameter validation. (Validation needed in production)  
- The size of QR code is 250x250 pixels.
- A public key file used for signature verification should be PEM format. See /ssh/id_rsa_jwt_qrcode_sample.pub

## Display QR code
1. Firstly, display the following URL on your web browser.

  http://localhost:3000/jwt_qrcode
  
  The QR code will be expired in 5 minutes after displayed.

2. The following screen will be displayed.

  ![image](/images/qrcode_rqrcode.png)

  A history record will be inserted into the 'jwt_qrcode' table as below.

| id | jwt | data | user_id |
|:-----------|------------:|------------:|------------:|
| 1       | eyJhbGciOiJSUzI1NiJ9 ... qEnpJcU3IueC7hjuM8FyCCwZuCBpsHu8Q | some data you want to process ... |     |

## Processing QR code
  Send a HTTP request to process a jwt embedded in a QR code from your mobile application after scanning it.
  But We'll use cURL instead of Mobile application here because of no sample mobile appliciation.

- The example of sending a request using PUT method through cURL.

  ```
  $ curl -X PUT http://localhost:3000/jwt_qrcode -F "jwt=eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJKd3QtUXJjb2RlLVNhbXBsZSIsImlhdCI
  6MTUwNzUzMjc1NSwiZXhwIjoxNTA3NTMzMDU1LCJkYXRhIjoiNTI0NTA1OTJiMTFkMWI0OGM5MzU5Y2NlNzYxMjRlZWVhZjI4N2RiZWMzNTA4ZGQ0OWE2OT
  E5YWIxOTExOWYwNyJ9.kmJTjJy8DkfdcmaCt_RaktdtN2XITHPbRRIIwaSF83IcYIbgd2fzcHu-lf6-1wRw-uhlGTT6Wo4M1i7p7FWn22syd3aQVyAO_u7v
  DTNP6klskFOBnHKHK_pqGdYrJ4IpLEUCwmAJ3TXYhPSkSF2r06E7mR9FbwNVsSQ05QkQt63ijPwkLSE-ikSiCpjg39DAjHfBe0Mac3NlLeONVLp9oRy23g5
  4nhYK0ttTOG9ktCvTDgJki9EkrXsqht2ASWTBHe1DdOZuVXY902HHJKN0PPMbRDo99dHBKWXGMKHOzyffxzoDFIjeGqEnpJcU3IueC7hjuM8FyCCwZuCBps
  Hu8Q" -F "user_id=test_user"
  ```

  #### The details of parameters
    "jwt": A jwt embedded in a QR code.

    "user_id": An user_id of your_mobile application.
  
  
  The correct response will be returned as follows if the JWT and user_id are valid.
  
  ```
  {"status":"ok"}
  ```

  And then, the value of parameter, 'test_user', has been set into the user_id column as below.

| id | jwt | data | user_id |
|:-----------|------------:|------------:|------------:|
| 1       | eyJhbGciOiJSUzI1NiJ9 ... qEnpJcU3IueC7hjuM8FyCCwZuCBpsHu8Q | some data you want to process ... | test_user |  

- If the JWT's signature is expired, an error response will be returned.
  ```
  $ curl -X PUT http://localhost:3000/jwt_qrcode -F "jwt=eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJKd3QtUXJjb2RlLVNhbXBsZSIsImlhdCI
  6MTUwNzUzMjc1NSwiZXhwIjoxNTA3NTMzMDU1LCJkYXRhIjoiNTI0NTA1OTJiMTFkMWI0OGM5MzU5Y2NlNzYxMjRlZWVhZjI4N2RiZWMzNTA4ZGQ0OWE2OT
  E5YWIxOTExOWYwNyJ9.kmJTjJy8DkfdcmaCt_RaktdtN2XITHPbRRIIwaSF83IcYIbgd2fzcHu-lf6-1wRw-uhlGTT6Wo4M1i7p7FWn22syd3aQVyAO_u7v
  DTNP6klskFOBnHKHK_pqGdYrJ4IpLEUCwmAJ3TXYhPSkSF2r06E7mR9FbwNVsSQ05QkQt63ijPwkLSE-ikSiCpjg39DAjHfBe0Mac3NlLeONVLp9oRy23g5
  4nhYK0ttTOG9ktCvTDgJki9EkrXsqht2ASWTBHe1DdOZuVXY902HHJKN0PPMbRDo99dHBKWXGMKHOzyffxzoDFIjeGqEnpJcU3IueC7hjuM8FyCCwZuCBps
  Hu8Q" -F "user_id=test_user"  
  
  {"status":"error","detail":"Signature has expired"}
  ```
  
- If the JWT's signature is invalid, an error response will be returned. Let's replace the last character of the signature capital "Q" with small "q".
  ```
  $ curl -X PUT http://localhost:3000/jwt_qrcode -F "jwt=eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJKd3QtUXJjb2RlLVNhbXBsZSIsImlhdCI
  6MTUwNzUzMjc1NSwiZXhwIjoxNTA3NTMzMDU1LCJkYXRhIjoiNTI0NTA1OTJiMTFkMWI0OGM5MzU5Y2NlNzYxMjRlZWVhZjI4N2RiZWMzNTA4ZGQ0OWE2OT
  E5YWIxOTExOWYwNyJ9.kmJTjJy8DkfdcmaCt_RaktdtN2XITHPbRRIIwaSF83IcYIbgd2fzcHu-lf6-1wRw-uhlGTT6Wo4M1i7p7FWn22syd3aQVyAO_u7v
  DTNP6klskFOBnHKHK_pqGdYrJ4IpLEUCwmAJ3TXYhPSkSF2r06E7mR9FbwNVsSQ05QkQt63ijPwkLSE-ikSiCpjg39DAjHfBe0Mac3NlLeONVLp9oRy23g5
  4nhYK0ttTOG9ktCvTDgJki9EkrXsqht2ASWTBHe1DdOZuVXY902HHJKN0PPMbRDo99dHBKWXGMKHOzyffxzoDFIjeGqEnpJcU3IueC7hjuM8FyCCwZuCBps
  Hu8q" -F "user_id=test_user"
  {"status":"error","detail":"Signature verification raised"}
  ```
  
- If the QR code already processed, an error response will be returned.
  ```
  $ curl -X PUT http://localhost:3000/jwt_qrcode -F "jwt=eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJKd3QtUXJjb2RlLVNhbXBsZSIsImlhdCI
  6MTUwNzUzMjc1NSwiZXhwIjoxNTA3NTMzMDU1LCJkYXRhIjoiNTI0NTA1OTJiMTFkMWI0OGM5MzU5Y2NlNzYxMjRlZWVhZjI4N2RiZWMzNTA4ZGQ0OWE2OT
  E5YWIxOTExOWYwNyJ9.kmJTjJy8DkfdcmaCt_RaktdtN2XITHPbRRIIwaSF83IcYIbgd2fzcHu-lf6-1wRw-uhlGTT6Wo4M1i7p7FWn22syd3aQVyAO_u7v
  DTNP6klskFOBnHKHK_pqGdYrJ4IpLEUCwmAJ3TXYhPSkSF2r06E7mR9FbwNVsSQ05QkQt63ijPwkLSE-ikSiCpjg39DAjHfBe0Mac3NlLeONVLp9oRy23g5
  4nhYK0ttTOG9ktCvTDgJki9EkrXsqht2ASWTBHe1DdOZuVXY902HHJKN0PPMbRDo99dHBKWXGMKHOzyffxzoDFIjeGqEnpJcU3IueC7hjuM8FyCCwZuCBps
  Hu8Q" -F "user_id=test_user"
  {"status":"error","detail":"This QR Code has already been scanned."}
  ```
  
- If the user_id parameter is not equals to that of JWT's user_id claim, an error response will be returned.
  ```
  $ curl -X PUT http://localhost:3000/jwt_qrcode -F "jwt=eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJKd3QtUXJjb2RlLVNhbXBsZSIsImlhdCI
  6MTUwNzUzMjc1NSwiZXhwIjoxNTA3NTMzMDU1LCJkYXRhIjoiNTI0NTA1OTJiMTFkMWI0OGM5MzU5Y2NlNzYxMjRlZWVhZjI4N2RiZWMzNTA4ZGQ0OWE2OT
  E5YWIxOTExOWYwNyJ9.kmJTjJy8DkfdcmaCt_RaktdtN2XITHPbRRIIwaSF83IcYIbgd2fzcHu-lf6-1wRw-uhlGTT6Wo4M1i7p7FWn22syd3aQVyAO_u7v
  DTNP6klskFOBnHKHK_pqGdYrJ4IpLEUCwmAJ3TXYhPSkSF2r06E7mR9FbwNVsSQ05QkQt63ijPwkLSE-ikSiCpjg39DAjHfBe0Mac3NlLeONVLp9oRy23g5
  4nhYK0ttTOG9ktCvTDgJki9EkrXsqht2ASWTBHe1DdOZuVXY902HHJKN0PPMbRDo99dHBKWXGMKHOzyffxzoDFIjeGqEnpJcU3IueC7hjuM8FyCCwZuCBps
  Hu8Q" -F "user_id=dummy"    
  {"status":"error","detail":"Invalid user scanned the QR code."}
  ```
  
## Licence
  [MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author
  [Kenji Wakabayashi](https://github.com/wakaken)
