conn sys as sysdba/123456;

drop user elec_dan_q1 cascade;
drop user elec_dan_q2 cascade;
drop user elec_dan_q3 cascade;
drop user elec_dan_q4 cascade;
drop user elec_dan_q5 cascade;

drop user elec_lapctr_q1 cascade;
drop user elec_lapctr_q2 cascade;
drop user elec_lapctr_q3 cascade;
drop user elec_lapctr_q4 cascade;
drop user elec_lapctr_q5 cascade;

drop user elec_theodoi_q1 cascade;
drop user elec_theodoi_q2 cascade;
drop user elec_theodoi_q3 cascade;
drop user elec_theodoi_q4 cascade;
drop user elec_theodoi_q5 cascade;

drop user elec_giamsat_q1 cascade;
drop user elec_giamsat_q2 cascade;
drop user elec_giamsat_q3 cascade;
drop user elec_giamsat_q4 cascade;
drop user elec_giamsat_q5 cascade;

drop role elec_roles;
drop user elec_sec_admin cascade;
drop user elec_user_manage cascade;
drop user elec cascade;


conn lbacsys/123456;

begin
    SA_SYSDBA.DROP_POLICY(
        policy_name => 'access_election',
        drop_column => true
    );

end;
/