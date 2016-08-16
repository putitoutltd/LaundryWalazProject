<?php

class TestController extends BaseController
{

    protected function _register_user()
    {
        $randEmail = substr(md5(microtime()), rand(0, 26), 8);
        $data = "first_name=shahbaz-shahbaz&sur_name=mohammad&email=$randEmail@mail.com&password=123456&age=10&gender=male&country=pakistan&newsletter=1";
        Poster::post(Utility::base_url() . '/api/save-registration', $data);
    }

    protected function _user_email_check()
    {
        Poster::post(Utility::base_url() . '/api/check-email', 'email=shahbaz@mail.com');
    }

    protected function _register_device()
    {
        $data = 'token={7AFC2F8A-3933-40CE-9576-EEA53C883722}';
        $data .= '&platform=android';
        $data .= '&device_token=5ac4c17ef471897fe3c204867a877f5d47703a6811a588b359fc1b161bc40826';
        Poster::post(Utility::base_url() . '/api/register-device-token/', $data);
    }

    protected function _send_test_email()
    {
        $to = 'rashid.akram@putitout.co.uk';
        $subject = 'test email';
        $message = 'test email from putitout';
        echo Utility::sendEmail('service@laundrywalaz.com',  'Laundrywalaz' , $to,$subject , $message);
        
        echo '<br /> testing...';
    }

}
