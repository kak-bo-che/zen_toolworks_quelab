int x_limit = 9;
int y_limit = 10;
int z_limit = 12;
int probe =   A5;
int x_last = HIGH;
int y_last = HIGH;
int z_last = HIGH;
int probe_last = HIGH;

void setup() {
  // set the digital pin as input:
   pinMode(x_limit, INPUT_PULLUP);
   pinMode(y_limit, INPUT_PULLUP);
   pinMode(z_limit, INPUT_PULLUP);
   pinMode(probe, INPUT_PULLUP);

   Serial.begin(115200);
}

void test_switch_state(int limit_switch, char * limit_name, int &last_state){
  if (digitalRead(limit_switch) != last_state){
     delay(100);
     last_state = digitalRead(limit_switch);
     Serial.print(limit_name);
     if(last_state == HIGH){
       Serial.print(" limit OFF\n");
     } else {
       Serial.print(" limit ON\n");
     }
  }
}

void loop(){
  test_switch_state(x_limit, "X", x_last);
  test_switch_state(y_limit, "Y", y_last);
  test_switch_state(z_limit, "Z", z_last);
  test_switch_state(probe, "Probe", probe_last);
}

