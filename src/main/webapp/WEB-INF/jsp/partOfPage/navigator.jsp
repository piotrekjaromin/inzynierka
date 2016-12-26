<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!-- Navigation -->
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/TrafficThreat">Traffic Threat</a>
    </div>
    <!-- /.navbar-header -->

    <ul class="nav navbar-top-links navbar-right">

        </li>
        <!-- /.dropdown -->
        <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
            </a>
            <ul class="dropdown-menu dropdown-user">
                <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
                    <li><a href="/TrafficThreat/user/userProfile"><i class="fa fa-user fa-fw"></i> User Profile</a>
                    </li>
                    <li><a href="#"><i class="fa fa-gear fa-fw"></i> Settings</a>
                    </li>
                    <li class="divider"></li>
                    <li><a href="/TrafficThreat/logout"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                    </li>
                </sec:authorize>
                <sec:authorize access="hasRole('ADMIN')">
                    <li>
                        <a href="/TrafficThreat/registration"><i class="fa fa-gear fa-fw"></i> Sign Up Admin</a>
                    </li>
                </sec:authorize>

                <sec:authorize access="isAnonymous()">
                    <li>
                        <a href="/TrafficThreat/login"><i class="fa fa-sign-out fa-fw"></i> Log In</a>
                    </li>
                    <li>
                        <a href="/TrafficThreat/registration"><i class="fa fa-gear fa-fw"></i> Sign Up</a>
                    </li>
                </sec:authorize>
            </ul>
            <!-- /.dropdown-user -->
        </li>
        <!-- /.dropdown -->
    </ul>
    <!-- /.navbar-top-links -->

    <div class="navbar-default sidebar" role="navigation">
        <div class="sidebar-nav navbar-collapse">
            <ul class="nav" id="side-menu">
                <li>
                    <a href="/TrafficThreat"><i class="fa fa-dashboard fa-fw"></i> Dashboard</a>
                </li>
                <li>
                    <a href="#"><i class="fa fa-bar-chart-o fa-fw"></i> Show Threats<span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="/TrafficThreat/showApprovedThreats">Approved</a>
                        </li>
                        <sec:authorize access="hasRole('ADMIN')">
                            <li>
                                <a href="/TrafficThreat/showNotApprovedThreats">Not Approved</a>
                            </li>
                            <li>
                                <a href="/TrafficThreat/showAllThreats">All</a>
                            </li>
                        </sec:authorize>
                    </ul>
                    <!-- /.nav-second-level -->
                </li>
                <sec:authorize access="hasAnyRole('ADMIN', 'USER')">
                    <li>
                        <a href="/TrafficThreat/user/addThreat"><i class="fa fa-dashboard fa-fw"></i> Add Threat</a>
                    </li>
                </sec:authorize>
                <sec:authorize access="hasAnyRole('ADMIN')">
                    <li>
                        <a href="/TrafficThreat/admin/showUsers"><i class="fa fa-dashboard fa-fw"></i> Show Users</a>
                    </li>
                    <li>
                        <a href="/TrafficThreat/admin/addThreatType"><i class="fa fa-dashboard fa-fw"></i> Add Threat Type</a>
                    </li>
                </sec:authorize>
            </ul>
        </div>
        <!-- /.sidebar-collapse -->
    </div>
    <!-- /.navbar-static-side -->
</nav>
