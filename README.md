# leader-detection
By [Or Tslil](https://github.com/ortslil64)

In a swarm of robots, who is the leader?
Hierarchy detection using autoregression Kalman filter estimation implementation in matlab.

## Algorithm
To detect the leader we estimate to autoregression parameters that the robots affect each other. We use Kalman filter the estimates those parameters over time, where the observations are the robots positions and the process model is a random walk.
The leader is estimated by the L2 norm of the autoregression parameters. So that if one robots "effects" the others, more then any othere - hi is the leader. 

## Example
[![Watch the video](https://img.youtube.com/vi/SJLq1mqJAB0/default.jpg)](https://youtu.be/SJLq1mqJAB0)
## Dependencies
The following python packges are required:
* matlab 2016 a +

## Runing
For a demo simulation use (in matlab):


```
main
```

