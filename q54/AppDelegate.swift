//
//  AppDelegate.swift
//  q54
//
//  Created by Manuel Klarmann Eaternity on 12.06.14.
//  Copyright (c) 2014 Eaternity. All rights reserved.
//

import Cocoa


class Neuron {
    var indentification = Int()
    var synapses = [Int: Synapse]()
    var inputStack = Dictionary<Int, Signal>() // one could limit the stack to the last pushes / the connection information is partly redundant to synapses to differ between incoming and outgoing signals
    var connections = Array<Int>()
    var signal = Signal()
    
    var question = String()
    var answers = Array<String>()
    
    var entropy = Double()
    // create signal function
    // propagate signal
    // lean with feedbacked error
    
}

var network = Dictionary<Int, Neuron>()

class Signal {
    var potential  = Double()
    var identifikation = Int()
}


class Synapse {
    var weight = Double()
    var identification = Int() // where does the signal come from
}

func sigmoid(input: Double) -> Double {
    
    var x:Double = input // include bias??
    if (x < -45.0) { return 0.0 }
    else if (x > 45.0) { return 1.0 }
    else { return 1.0 / (1.0 + exp(-x)) }
}




func createSignal(neuron: Neuron) -> Signal {

    var signal = Signal()
    signal.identifikation = neuron.indentification
    signal.potential = sigmoid(sumInputs(neuron, neuron.inputStack))
    return signal
}


func sumInputs(neuron:Neuron, inputStack:Dictionary<Int, Signal>) -> Double {
    
    var sum = 0.0
    for input in inputStack.values {
        if let synapse = neuron.synapses[input.identifikation] {
            sum = sum + synapse.weight*input.potential
        }
    }
    
    return sum
}


func sendSignals(network: Dictionary<Int, Neuron>) {
    for neuron in network.values {
        neuron.signal = createSignal(neuron)
    }
    
    for neuron in network.values { // this is a simultaneous update, without an order!
        for connection in neuron.connections {
            network[connection]!.inputStack[neuron.indentification] = neuron.signal
        }
        
    }
}


func calculateError (neuron: Neuron, expectedOutput: Double) -> Double {
    var error:Double  = createSignal(neuron).potential - expectedOutput
    NSLog("Neuron: \(neuron.indentification) error: \(error) expected output: \(expectedOutput)")
    return error*error // abs(error)
}

func calculateNetworkError (network: Dictionary<Int, Neuron>) {
    
}

var knowledgeGraph = Array<UserInputChain>()


class UserInputChain {
    var userChain = Dictionary<Int,UserInput>() // all collection of all userinputs
}

class UserInput {
    var indentification = Int() // identification of neuron?
    var target = Double()
}


func energy (network: Dictionary<Int, Neuron>, data: Array<UserInputChain>) -> Double {
    // sum of all squared errors of all neurons given all inputs
    var energy:Double = 0.0
    
    for userinputchain in data {
        for userinput in userinputchain.userChain.values {
            var neuron:Neuron! = network[userinput.indentification]
            energy += calculateError(neuron,userinput.target)
        }
    }
    return energy
}

func createSituation(userChain: Dictionary<Int,UserInput>) -> Dictionary<Int, Signal>{
    // define purpose of creating a situation!? - this may to much code think of restructering objects or funtions...
    
    var situation = Dictionary<Int, Signal>()
    for value in userChain.values {
        // if key has a connection, store information
        var signal = Signal()
        signal.identifikation = value.indentification
        signal.potential = value.target
        situation[value.indentification] = signal
    }
    return situation
    
}

var eta:Double =  0.90      // eta (learning rate)
var alpha:Double =  0.04    // alpha (momentum for learning rate)

func updateWeights (network: Dictionary<Int, Neuron>, data: Array<UserInputChain>) {
    
    eta = eta + ((1-eta) * alpha)

    for neuron in network.values { // shouldn't this be iterating over userinputs first?
        
        NSLog("Updating Neuron\(neuron.indentification) ...")
        
        for userinputchain in data {
            
            var knowledge:UserInput! = userinputchain.userChain[neuron.indentification]
            
            var situation = createSituation(userinputchain.userChain)
            
            
            var signal:Double = sigmoid(sumInputs(neuron, situation))
            var error: Double = knowledge.target - signal
            
            
            NSLog("Neuron: \(neuron.indentification) error: \(error) expected output: \(knowledge.target) with eta: \(eta)")
            
            var derivative: Double = (1 - signal) * signal // this is the derivative of the sigmoid (1 / 1 + exp(-x))
            

            for synapse in neuron.synapses.values {

                NSLog("Neuron\(neuron.indentification) Synapse\(synapse.identification) before \(synapse.weight)")
                
                synapse.weight = synapse.weight + (error * eta * derivative * situation[synapse.identification]!.potential)
                
                // taken from tutorial https://www4.rgu.ac.uk/files/chapter3%20-%20bp.pdf
                
                NSLog("Neuron\(neuron.indentification) Synapse\(synapse.identification) after \(synapse.weight)")
            }
        }
    }
} // UpdateWeights

// update for hidden layer weights -> weight_before_new = weight_before (error*new_weight_later*derivative) * input_weight_before


func initialize() -> Package  {

    NSLog("start")
    

    /*
    return "This neuron signals \(numberOfSides) other neurons with the sigmoid from the weighted sum of its inputs."
    
    modeled according:
    http://www.gatsby.ucl.ac.uk/~dayan/papers/hdfn95.pdf
    http://msdn.microsoft.com/en-us/magazine/jj658979.aspx
    
    */
    

    //var identifications = [123,123,123]
    //var axonLengths = [1,1,1]
    
    //class NeuronConnections {
    //    var identification = Int()
    //    var axonLength = Int() // to enforce lateral connections
    //}
    // This a consideration to prune unneccessary connection and keep the network lean.
    
    
    var synapse1 = Synapse()
    synapse1.weight = 1.7
    synapse1.identification = 0
    
    var synapse2 = Synapse()
    synapse2.weight = 3.3
    synapse2.identification = 0
    
    var synapse3 = Synapse()
    synapse3.weight = 2.6
    synapse3.identification = 1
    
    var synapse4 = Synapse()
    synapse4.weight = -1.0
    synapse4.identification = 1
    
    var synapse5 = Synapse()
    synapse5.weight = 2.6
    synapse5.identification = 2
    
    var synapse6 = Synapse()
    synapse6.weight = -1
    synapse6.identification = 2
    
    var synapses: Dictionary<Int, Synapse> = [synapse1.identification: synapse1, synapse3.identification: synapse3, synapse5.identification: synapse5] // neuron 1
    var synapses2: Dictionary<Int, Synapse> = [synapse2.identification: synapse2, synapse4.identification: synapse4, synapse6.identification: synapse6] // neuron 2
    
    
    var signal = Signal();
    signal.identifikation = 2
    signal.potential = 0.12 // signals neuron 1
    
    var signal2 = Signal();
    signal2.identifikation = 1
    signal2.potential = 0.31 // signals neuron 2
    
    
    var neuron0 = Neuron()
    neuron0.indentification = 0 // This is the bias neuron
    
    var neuron1 = Neuron()
    neuron1.indentification = 1
    neuron1.question = "Are you seeking for answers?"
    neuron1.answers = ["no","yes"]
    neuron1.synapses = synapses
    neuron1.inputStack[2] = signal
    neuron1.connections.append(0)
    neuron1.connections.append(1)
    neuron1.connections.append(2)
    
    var neuron2 = Neuron()
    neuron2.indentification = 2
    neuron2.question = "Are you satisfied?"
    neuron2.answers = ["no","yes"]
    neuron2.synapses = synapses2
    neuron2.inputStack[1] = signal2
    neuron2.connections.append(0)
    neuron2.connections.append(2)
    neuron2.connections.append(1)
    
    // Network
    network = [neuron0.indentification: neuron0, neuron1.indentification: neuron1, neuron2.indentification: neuron2]
    
    
    var userinput0 = UserInput()
    userinput0.indentification = 0
    userinput0.target = 0.5
    
    var userinput1 = UserInput()
    userinput1.indentification = 1
    userinput1.target = 1.0 // yes - I am seeking for answers
    
    var userinput2 = UserInput()
    userinput2.indentification = 2
    userinput2.target = 0.0 // no - I am not satisfied
    
    var initialInput = UserInputChain()
    initialInput.userChain = [userinput0.indentification: userinput0, userinput1.indentification: userinput1, userinput2.indentification: userinput2]
    
    // Input
    knowledgeGraph = [initialInput]
    
    var package = Package()
    package.network = network
    package.userinputchain = knowledgeGraph
    
    // -> if not satified:
    var interaction: String = "Can you tell me something special I might have missed about X?"
    // Answer: I was looking for David Hasselhof / Are you looking for David Hasselhof
    // -> Create a new neuron with this question and play the game again.
    
    return package
}

class Package {
    var userinputchain = Array<UserInputChain>()
    var network = Dictionary<Int,Neuron>()
    
}


func entropy(network: Dictionary<Int,Neuron>,chain: UserInputChain) -> Int {
    var nextNeuronId = Int()
    
    
    var max = 0.0
    for neuron in network.values {
        neuron.entropy = entropy(neuron,chain)
        if max < neuron.entropy {
            nextNeuronId = neuron.indentification
            max = neuron.entropy
        }
    }
    
//    calculate for each neuron that has no userinput yet, the information
//    
//    calculate for each neuron based on its possible outcomes, how this effects the information of every connected neuron (that i)
//    and sum up which is most reduced
//    
//    
//    for each
//    
//    find out, about the not yet given possible inputs
//    
//    sample each one as 0 and 0.5 and 1 (or the user pattern) as inputs
//    
//    choose the one, that decrease shannon entropy the most?
//    
    
    return nextNeuronId
}


func entropy(neuron: Neuron,chain: UserInputChain) -> Double {

        
        var situation = createSituation(chain.userChain)
        
        var sum = 0.0
        for input in situation.values {
            if let synapse = neuron.synapses[input.identifikation] {
                sum = sum + synapse.weight*input.potential
            }
        }

        var mutations = Array<Int>()
        for synapse in neuron.synapses.values {
            if !(situation[synapse.identification] != nil) {
                mutations.append(synapse.identification)
            }
        }
        
        
        // sample 10/5 variants, because our counting system is terniary
        
        var string = ""
        while count(string) < mutations.count {
            string = string + "9"
        }
      
      
        var entropy = 0.0
        var n = 0
        while n < string.toInt() {
            var string = "\(n)"
            
            var handleString = string
            var oneSituation = Dictionary<Int, Signal>()
            for index in mutations {
                var signal = Signal()
                signal.identifikation = index
                var double = Double(string.substringToIndex(advance(string.startIndex, 1)).toInt()!)
                signal.potential = double * 0.1
                
                oneSituation[index] = signal
                handleString = handleString.substringToIndex(advance(handleString.startIndex, 1))
            }
            
           
            var more = sum
            for input in oneSituation.values {
                if let synapse = neuron.synapses[input.identifikation] {
                    more = more + synapse.weight*input.potential
                }
            }
            
            entropy = entropy + sigmoid(more)*log(sigmoid(more))
            
            
            n = n + 5
        }
    

    return entropy
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow!
    
    @IBOutlet var resultTextField : NSTextField!
    @IBOutlet var inputTextField : NSTextField!
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
         NSLog("launch")
        
        // i cant get this bullshit to work
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        NSLog("terminate")
    }
    
    @IBAction func clickedTrain(sender : AnyObject) {
        
        var package = initialize()
        
//        self.resultTextField.stringValue = package.network[1]?.question
        
        
        var n = 0
        while n < 400 {
            // sendSignals(network)
            // calculateNetworkError(network)
            updateWeights(package.network, package.userinputchain)
            
            n++
        }
        
        var id = entropy(package.network, package.userinputchain[0])
        self.inputTextField.stringValue = "next up neuron is \(id)"
        
    }
    
    

    
    @IBAction func clicked(sender : AnyObject) {
        
  
        
//        if neuron omega yes -> start training
//            display first question
//        
//        if neuron omega no -> ask question what has been missed. Add it to the cycle
//        
//        continue with the routine
//        
//        routine:
//            calculate based on previous input and user, the next most interesting question (that maximizes knowledge)
//        
        

        
        
        
        
        NSLog("click")
               for neuron in network.values {
//            self.resultTextField.stringValue = "neuron  \(neuron.indentification) has the potential:  \(neuron.signal.potential). The energy is:"
        }
        
    }
    
    
    // yet another interesting read: https://www.byclb.com/TR/Tutorials/neural_networks/ch10_1.htm
    
    // optimization library: https://github.com/mattt/Surge
}
