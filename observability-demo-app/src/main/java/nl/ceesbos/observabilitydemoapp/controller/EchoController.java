package nl.ceesbos.observabilitydemoapp.controller;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
public class EchoController {

    @GetMapping("/")
    public String index() {
        return "Greetings from Observability demo app!";
    }
}
