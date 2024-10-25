package pe.edu.vallegrande.sysrestaurant.test;

import pe.edu.vallegrande.sysrestaurant.service.dashboard.DashboardService;

public class test02 {
    public static void main(String[] args) {
       int a = new DashboardService().countOrdersPending();
         System.out.println(a);
    }
}
