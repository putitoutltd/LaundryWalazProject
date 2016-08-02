<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title><?php echo $page_title; ?></title>

    <!-- Bootstrap Core CSS -->
    <link href="<?php echo Utility::theme_url(); ?>css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="<?php echo Utility::theme_url(); ?>css/style.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
    #loader{
        
        z-index: 100;
        position: absolute;
        top: 50px;
        background-color: #797878;
        height: 50px;
        width: 100%;
        text-align: center;
        opacity: 0.9;
        display: none;
    }
    
    #loader span{
        color: #FFF;
        font-size: 15pt;
        
    }
    </style>
</head>

<body>
    
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <?php //echo $page_heading; ?>
        
        <div class="container">
            
            <!-- div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">Laundry Walaz</a>
            </div -->
            
            <!-- div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li>
                        <a href="<?php //echo Utility::base_url(); ?>/dashboard">About</a>
                    </li>
                    <li>
                        <a href="#"><?php //echo (isset($params['kyaha'])) ? $params['kyaha'] : 'Services' ?></a>
                    </li>
                    <li>
                        <a href="#">Contact</a>
                    </li>
                </ul>
            </div -->
            
        </div>
        
    </nav>
    <div id="loader"><span>Loading...</span></div>
    <!-- Page Content -->
    <div class="container">
        
        <div class="row">
            <?php 
                $currentAction =  filter_input(INPUT_SERVER, 'REQUEST_URI');
                
                $orderActive = (strpos($currentAction, 'orders')) ? ' active ' : '';
                $userActive = (strpos($currentAction, 'users')) ? ' active ' : '';
                $priceActive = (strpos($currentAction, 'pricing')) ? ' active ' : '';
                $reportActive = (strpos($currentAction, 'reports')) ? ' active ' : '';
            ?>
            <div class="col-md-2">
                <p class="lead"><a href="<?php echo Utility::base_url(); ?>/dashboard"><img width="100" src="<?php echo Utility::theme_url(); ?>images/logo.png" ></a></p>
                <div class="list-group">
                    <a href="<?php echo Utility::base_url(); ?>/orders" class="list-group-item <?= $orderActive; ?>">Orders</a>
                    <a href="<?php echo Utility::base_url(); ?>/users" class="list-group-item <?= $userActive; ?>">Users</a>
                    <a href="<?php echo Utility::base_url(); ?>/pricing" class="list-group-item <?= $priceActive; ?>">Pricing</a>
                    <a href="<?php echo Utility::base_url(); ?>/reports" class="list-group-item <?= $reportActive; ?>">Reports</a>
                    <a href="<?php echo Utility::base_url(); ?>/admin/logout" class="list-group-item">Logout</a>
                </div>
            </div>

            <div class="col-md-10">
                    <?php echo $page_body; ?>
            </div>

        </div>

    </div>
    <!-- /.container -->

    <div class="container">

        <hr>

        <!-- Footer -->
        <footer>
            <div class="row">
                <div class="col-lg-12">
                    <p>Copyright &copy; <a target="_blank" href="http://www.putitout.co.uk/">Putitout.co.uk </a><?= date('Y'); ?></p>
                </div>
            </div>
        </footer>

    </div>
    <!-- /.container -->

    <!-- jQuery -->
    <script src="<?php echo Utility::theme_url(); ?>js/jquery.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="<?php echo Utility::theme_url(); ?>js/bootstrap.min.js"></script>

    <!-- Custom -->
    <script src="<?php echo Utility::theme_url(); ?>js/custom.js"></script>
    
</body>

</html>
