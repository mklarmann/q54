//
//  q54Tests.swift
//  q54Tests
//
//  Created by Manuel Klarmann Eaternity on 12.06.14.
//  Copyright (c) 2014 Eaternity. All rights reserved.
//

import XCTest
import q54



// wenn du testen willst nur die Mathematische Funktion schreiben



class q54Tests: XCTestCase {
    
    // synapses to play with
    //    let synapse = Synapse()

    
    // end of variables
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
       
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSigmoid() {
        
            XCTAssert(sigmoid(0.0) == 0.5, "right in the middle")
            XCTAssert(sigmoid(100.0) == 1.0, "high value")
            XCTAssert(sigmoid(-100.0) == 0.0, "low value")
  
    }
    
    func testCreateSignal() {
        
  
        let signalTest = Signal()
        signalTest.identifikation = 1
        signalTest.potential = sigmoid(1.0*0.12)
        
        XCTAssert(createSignal(neuron).potential == signalTest.potential, "neuron shoots the right signal \(createSignal(neuron).potential) should be \(signalTest.potential)")
        
        
        neuron.inputStack[2] = signal2
        
        let signalTest2 = Signal()
        signalTest2.identifikation = 1
        signalTest2.potential = sigmoid(1.0*0.12-0.31*1.1)
        
        XCTAssert(createSignal(neuron).potential == signalTest2.potential, "neuron shoots the right signal \(createSignal(neuron).potential) should be \(signalTest.potential)")
        
    }
    
    func testSendSignals() {
        network = [neuron.indentification: neuron, neuron2.indentification: neuron2]
        
        XCTAssert(network[1]!.inputStack[1]!.potential == 0.12, "neuron shoots the right signal")
        XCTAssert(network[2]!.inputStack[1]!.potential == 0.31, "neuron shoots the right signal")
        
        XCTAssert(network[1]!.connections.count == 2, "neuron shoots the right signal")
        XCTAssert(network[2]!.connections.count == 2, "neuron shoots the right signal")
        
        sendSignals(network)
        
        var testvalue1 = sigmoid(1.0*0.12)
        var testvalue2 = sigmoid(2.0*0.31)
        
        XCTAssert(network[1]!.signal.potential == testvalue1, "neuron shoots the right signal \(network[1]!.signal.potential) should be \(testvalue1)")

        XCTAssert(network[2]!.signal.potential == testvalue2, "neuron shoots the right signal \(network[2]!.signal.potential) should be \(testvalue2)")

        
        XCTAssert(network[1]!.inputStack.count == 2, "input stack is \(network[1]!.inputStack.count) oh no")
        XCTAssert(network[2]!.inputStack.count == 2, "neuron shoots the right signal")
        
//        
//      XCTAssert(network[1]!.inputStack[1]!.potential == testvalue1, "neuron shoots the right signal")
//      XCTAssert(network[2]!.inputStack[1]!.potential == testvalue2, "neuron shoots the right signal")
        
 
    }
    
    func testCalculateError() {
        neuron.signal.potential = 1.0
        XCTAssert(calculateError (neuron, 1.0) == 0.0, "input stack is \(calculateError (neuron, 1.0)) oh no")
        
        neuron.signal.potential = 0.0
        XCTAssert(calculateError (neuron, 1.0) == 1.0, "input stack is \(calculateError (neuron, 1.0)) oh no")
        
        
        neuron.signal.potential = 0.5
        XCTAssert(calculateError (neuron, 1.0) == 0.25, "input stack is \(calculateError (neuron, 1.0)) oh no")
    }
    
    func testUpdateWeights() {
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
            var n = 0
            while n < 10 {
                // sendSignals(network)
                // calculateNetworkError(network)
                updateWeights(network, knowledgeGraph)
                
                n++
            }

        }
    }
    
}

