<?php

/**
 * Handles the all requests related to cronjobs
 * 
 * @author Muhammad Shahbaz <mohammadshahbax@mail.com>
 * @copyright (c) 2015, Putitout Solutions
 */
class CronController extends BaseController
{

    protected function _broadcast_push_notifications()
    {
        echo "\n############# START: Push Notification ###################\n";
        echo "\n", date("m/d/Y h:i:s"), "\n";
        $pushNotify = new ParseModel();
        $PushModel = new PushModel();

        $i = 0;
        $expireTime = time() + 55;
        while (time() < $expireTime) {
            $result = $PushModel->getPushData();
            if (!empty($result)) {
                foreach ($result as $row) {
                    $pushData = array(
                        //'title' => $row['title'],
                        //'body' => $row['body'],
                        'alert' => $row['title'],
                        'sound' => '',
                            //'badge' => "Increment"
                    );
                    if ($row['data'] != null) {
                        $extraData = json_decode($row['data'], true);
                        $pushData['data'] = $extraData;
                    }
                    /* Start: IOS PUSH */
                    $responseJson = $pushNotify->sendPush($pushData, $row['device'], $row['device_token']);
                    $responseArray = json_decode($responseJson);
                    if ($responseArray) {
                        $i++;
                        $PushModel->updatePush($row['push_id']);
                    }
                }
            } else {
                //break;
            }

            sleep(5);
        }
        echo "\n", date("m/d/Y h:i:s"), "\n";
        echo "\n############# END: Push Notification : sent = $i #################\n";
        //header('Refresh: ' . '60');
    }
    
    protected function _generate_vaccination_activity(){
        
        $vaccinationModel = new VaccinationModel();
        $currentDate = date('Y-m-d');
        $vaccinationDate = date('Y-m-d', strtotime('+3 days',strtotime($currentDate)));
        $vaccinations = $vaccinationModel->getChildrenVaccination($vaccinationDate);
        
        foreach($vaccinations as $vaccination){
            // adding comment activity start
            $fullName = Utility::concatNotEmptyValues(array($vaccination['c_fname'],$vaccination['c_mname'],$vaccination['c_lname']));
            $message = str_replace('#var#',$fullName, Messages::getMessage('vaccination'));
            $activityData = array(
               'notification_type' => 'vaccination',
               'description'       => $message,
               'read_status'       => 'N',
               'notify_user'       => $vaccination['user_id'], 
               'related_to'        => 'children',
               'related_id'        => $vaccination['children_id'],
               'additional_info'   => json_encode($vaccination),
               'user_id'           => $vaccination['user_id'],
               'date_created'      => $currentDate
            );
            $activityId = Utility::recordActivity($activityData);
            
            // array to show some output on successful cron
            $output = array(
                'currentDate' => $currentDate,
                'activityId' => $activityId,
            );
            
            $deviceModel = new DevicesModel();
            $device = $deviceModel->getDeviceByUserId($vaccination['user_id']);
            if(!empty($device['device_token'])){
                $pushModel = new UrbanAirshipModel();
                $data = array(
                    'alert' => $message
                );
                $pushResponse = $pushModel->sendPush($data, $device['device_token']);
                $output['push_sent'] = (isset($pushResponse->ok) && $pushResponse->ok == 1) ? 'Yes' : 'No';
            } 
            echo json_encode($output);
        }
    }
    

}
