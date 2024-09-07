## Development of an LED lamp that simulates sunrise
This lamp had two iterations; The first iteration was a desk lamp using the frame of a compact fluorescent based desk lamp which I gutted. The second prototype was a more involved build which I initially intended to replace an LED strip I had above my desk but ended up being more useful as a dimmable room lamp.

## The first prototype
The first prototype was planned and built on a whim in a single weekend. When I was building it, I was doing so mainly as an exercise to design a constant current LED driver using the MP2480. But in doing so I realized I could stick an MCU in there and fulfill a project idea I'd had for a while. Using the MCU's RTC I could keep track of time and slowly brighten the lamp at a specified time, essentially simulating a sunrise and helping me wake up for early morning classes in the winter (before the sun actually rose).

The software for this prototype was then slowly developed over the course of a month and even more slowly debugged over the course of a year whenever I felt like dealing with it.

Annoyingly though, my terrible code meant I had to set the time the night before each early morning class, which meant I had to hook up the whole lamp to my computer through a UART dongle. I never had a chance to fix this during the two semesters I used it, so I just lived with it*. Even with this barely functioning early prototype, I could see a huge difference in how easily I woke up. It was a *night and day* difference. On days without the lamp, I woke up as if from a deep sleep with a barely functioning brain. With the lamp, I woke up much more easily and feeling more refreshed.
\* By the second semester I'd fixed it so I wouldn't have to set the time before each class. But if the power went out or class times changed I would still have to set everything up again through UART.

## Lets make another (the second prototype)
As explained above, this prototype was intended to replace a light strip and initially started because I wanted to try my hand at making another LED driver board

### Software
Initially I'd started writing the software for the STM32 completely from scratch in bare metal C with no help libraries*. The first version of the lamp used these handwritten libraries. I then switched to using libopencm3 for more robust and WAY faster development.
\* It was a good way to get started and learn the intricacies of this type of programming but I don't see myself doing this again if I don't have to.

For the UART interface I wrote a terminal interface which stores an array of commands as well as an array of function pointers. When the MCU receives a command, it calls the corresponding function. I did it this way so it would be easily expandable for many commands.

I'd been thinking for a while about how I could wirelessly control and communicate with this new lamp. Initially I wanted to make a [433MHz wireless transceiver](../radio_oscillator/index.html) and communicate using that, but just making the transmitter told me a had a bit to learn before I could do that. I then settled on using infra red diodes and detectors.

The IR library has two modes. In normal mode it simply receives bytes and puts them into the receive buffer**. In terminal mode, any byte it receives is sent straight to the UART terminal interface's command buffer; This way I can essentially remotely type into the lamp's terminal. To enter terminal mode, byte 0x02 must be received. The lamp will automatically exit terminal mode after a timeout or after byte 0x03 is received.
\** A byte in this case is used as a command (e.g. Lamp on, brightness up, etc)

To fix the issue of power outages causing the clock to reset I installed a coin cell battery and updated the software to make sure the RTC keeps counting even without Vcc. In doing this I also discovered that there exist persistent backup registers for storing arbitrary data through a power failure. I used this to store the daily alarms for each day of the week.

[insert state chart]
talk about ending up with a state machine structure for organizing events

### Hardware
## 3d printed case:
Started with the base where the boards are mounted
First modeled the bounds of the boards
should have accounted for screw lengths so I don't need many different lengths of screws

## Constant current supply
talk about extra capacitor and resistor used for 4 LEDs @ 12V

## Light strip:
[insert led soldered on heat sink]
[insert soldering iron tip]
Used a very large heavy iron tip for large thermal mass (easier to work with the big copper heat sink)
Flattened spots on wire heat sink for each led
Made sure flattened spots all point in same direction
Applied some solder to back of each led where it would normally attach to a heat sink

## Quality of Life
RTC battery
brightness potentiometer
IR remote control
