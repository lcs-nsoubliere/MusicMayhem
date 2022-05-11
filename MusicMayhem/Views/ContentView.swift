//
//  ContentView.swift
//  MusicMayhem
//
//  Created by Noah Alexandre Soubliere on 2022-05-06.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored Properties
    
    //these values are for the like button
    @State var circleColorChanged = false
    @State var heartColorChanged = false
    @State var heartSizeChanged = false
    
    //detect when an app moves between forground and backround (when the app goes on and off)
    //https://developer.apple.com/documentation/swiftui/environment
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var questionList: [TriviaQuestion] = []
    
    @State var currentQuestion: TriviaQuestion = TriviaQuestion(  category:
                                                                    "Entertainment: Music",
                                                                  type: "boolean",
                                                                  difficulty: "easy",
                                                                  question: "The music group Daft Punk got their name from a negative review they recieved.",
                                                                  correct_answer: "True",
                                                                  incorrect_answers: ["False"])
    
    
    
    
    
    
    
    //this will keep track of our list of favourit questions
    //the square brackets means its a list
    @State var favourites: [TriviaQuestion] = [] // <- the empty square brackets mean it starts emptpy
    
    //this will let us know wether the current question exists as a favourite
    @State var currentQuestionAddedToFavourites: Bool = false
    
    // MARK: Computed Properties
    
    var body: some View {
        VStack {
            ScrollView{
            Text(currentQuestion.question)
                .frame(width: 250, height: 150)
                .padding()
                .scaledToFit()
                .font(.title)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primary, lineWidth: 5)
                )
            
            //True and False Question
            HStack{
                Text("True")
                    .font(.system(size: 25))
                    .font(.title)
                    .padding(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2.5)
                    )
                
                Text("False")
                    .font(.system(size: 25))
                    .font(.title)
                    .padding(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary, lineWidth: 2.5)
                    )
            }
            .padding(10)
            
            
            //trying to get like button
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 40,
                       height: 40)
            //            ZStack {
            //                //create the circle that will chnage colour for the heart
            //                Circle()
            //                    .frame(width: 40, height: 40)
            //                    .foregroundColor(circleColorChanged ? Color(.systemGray5) : .red)
            //                    .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3))
            //
            //                //create the heart
            //                Image(systemName: "heart.fill")
            //                    .foregroundColor(heartColorChanged ? .red : .white)
            //                    .font(.system(size: 25))
            //                    .animation(nil)
            //
            //                // Cancel the animation from here
            //                    .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
            //                    .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3))
            //            }
            
            //                  condition                              true       false
                .foregroundColor(currentQuestionAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    //only add to list if it is not already there
                    if currentQuestionAddedToFavourites == false {
                        
                        //adds the current question to favourite list
                        favourites.append(currentQuestion)
                        
                        //record that we have marked this as a favourit
                        currentQuestionAddedToFavourites = true
                    }
                    
                }
            
            Button(action: {
                //the task allows us to run asynchronous code within a button and have the user interface be updated when the data is ready
                //since it is asynchronous, other tasks can run while we wait for the data to come back from the web server
                Task {
                    //call the fucntion (we created) that will load a new question
                    await loadNewquestion()
                }
            }, label: {
                Text("Another One!")
            })
                .buttonStyle(.bordered)
            
            Text("Favourites")
                .bold()
            
            Spacer()
            
            //this will iterate over the list of favourites
            //as we iterate, each individual favourit is
            //accessable via "currentFavourit"
                 ForEach(favourites, id: \.self) { currentFavourit in
                    Text(currentFavourit.question)
                }
            
        
            Spacer()
            
        }
        // When the app opens, get a new question from the web service
        .task {
            
            //load question from the endpoint
            //we are calling or invoking the function called "loadNewquestion"
            //the term for this is the "call sote" of a function
            //await means that we as the programmer are aware that this function is asyncronous
            //(results may come back rate away or might take a sec to load in)
            //also any code after this will run before this function is complete
            await loadNewquestion()
            
            
            //load favourites from the file saved on the device
            loadFavourites()
            
            
        }
        
        //react to chnages of state for the app (forground, backround, inactive)
        .onChange(of: scenePhase) {newPhase in
            
            if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .active {
                print("Active")
            } else if newPhase == .background{
                print("Background")
            }
            
            //permanatnky save the list of tasks
            persistFavourites()
        }
        .navigationTitle("Music Mayhem")
        .padding()
        
    }
    }
    
    //MARK: Function
    
    //define the function "loadNewquestion"
    //teaching our app to do a "new thing"
    //using th new async keyword means that this func might load/update alongside other task (it runs while the computer does other stuff)
    
    func loadNewquestion() async {
        
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://opentdb.com/api.php?amount=10&difficulty=easy&type=boolean")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new question
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentQuestion"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentQuestion = try JSONDecoder().decode(TriviaQuestion.self, from: data)
            
            print(currentQuestion)
            //reset the flag that tracks wether the current question
            //is a favourit
            currentQuestionAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
    
    //save the data permanently
    func persistFavourites() {
        
        //get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        print(filename)
        
        //try to encode the data in our list of favourites to JSON
        do {
            //create a JSON Encoder object
            let encoder = JSONEncoder()
            
            //configred the encoder to "pretty print" the JSON
            encoder.outputFormatting = .prettyPrinted
            
            //Encode the list of favourites we'ge collected
            let data = try encoder.encode(favourites)
            
            //write the JSON to a file in the filename we came up with earlier
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            //see the data that was written
            print("saved data to the documents directory successfully.")
            print ("=========")
            print(String(data: data, encoding: .utf8)!)
            
        } catch {
            print("Unable to write list of favourites to docuents directofy")
            print("========")
            print(error.localizedDescription)
            
        }
    }
    //loads the data that was saved
    func loadFavourites() {
        
        //get a location under which to save the data
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        print(filename)
        
        //attempt to load the data
        do {
            
            //load the raw data
            let data = try Data(contentsOf: filename)
            
            //see the data that was written
            print("read data from the documents directory successfully.")
            print ("=========")
            print(String(data: data, encoding: .utf8)!)
            
            //decode the JSON into swift native data structures
            favourites = try JSONDecoder().decode([TriviaQuestion].self, from: data)
            
        } catch  {
            //what went wrong
            print("could not load the data from the stored JSON file")
            print ("======")
            print(error.localizedDescription)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}

