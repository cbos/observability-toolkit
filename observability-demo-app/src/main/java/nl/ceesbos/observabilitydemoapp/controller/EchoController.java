package nl.ceesbos.observabilitydemoapp.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.concurrent.ThreadLocalRandom;

@RestController
public class EchoController {

    private final Logger logger = LoggerFactory.getLogger(EchoController.class);

    private final ThreadLocalRandom random = ThreadLocalRandom.current();

    @GetMapping("/")
    public String index() {

        logger.info("In index handler");
        return "Greetings from Observability demo app!";
    }

    @GetMapping("/random")
    public String randomBehaviour() throws InterruptedException {

        logger.info("In random behavior handler");

        Thread.sleep((long) (Math.abs((random.nextGaussian() + 1.0) * 200.0)));
        if (random.nextInt(10) < 3) {
            logger.error("Randomly failing to simulate an error");
            throw new RuntimeException("simulating an error");
        }

        return "Random greetings from Observability demo app!";
    }
}
