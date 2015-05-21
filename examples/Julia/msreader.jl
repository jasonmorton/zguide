import ZMQ

# Prepare our context and sockets
context = ZMQ.Context()

# Connect to task ventilator
receiver = ZMQ.Socket(context, ZMQ.PULL)
ZMQ.connect(receiver, "tcp://localhost:5557")

# Connect to weather server
subscriber = ZMQ.Socket(context,ZMQ.SUB)
ZMQ.connect(subscriber,"tcp://localhost:5556")
ZMQ.set_subscribe(subscriber, "10001")

# Process messages from both sockets
# We prioritize traffic from the task ventilator

while true

    # Process any waiting tasks
    while true
        println("checking for ventilator tasks")
        try
            msg = ZMQ.recv(receiver) #zmq.DONTWAIT is default for recv #hangs because errno()==EAGAIN, enters inner loop in ZMQ.jl
        catch er
            println(er)
            if isa(er,ZMQ.StateError)
                break
            end
            # process task
        end
    end

    # Process any waiting weather updates
    while true
        println("processing weather updates")
        try
            msg = ZMQ.recv(subscriber)
        catch er
            if isa(er,ZMQ.StateError)
                break
            end
        end
    end
    # process weather update

    # No activity, so sleep for 1 msec
    time.sleep(0.001)
    
end

