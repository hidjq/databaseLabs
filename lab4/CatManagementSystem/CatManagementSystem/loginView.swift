//
//  loginView.swift
//  CatManagementSystem
//
//  Created by Jachee Deng on 2022/12/17.
//

import SwiftUI

struct loginView: View {
    @Binding var isLogin:Bool
    @State var errorReason:String?
    @State var username:String = ""
    @State var  passwd:String = ""
    var body: some View {
        VStack {
            Text("LOGIN")
                .font(.largeTitle)
                .bold()
                .padding()
            TextField("Username", text: $username)
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .padding()
                
            TextField("Password", text: $passwd)
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(10)
                .padding()
            
            Button{
                guard let url = URL(string:"http://localhost:8081/finduser/\(username)/\(passwd)") else {
                    print("Not fund url")
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, res, error in
                    if error != nil {
                        print("error",error?.localizedDescription ?? "")
                        return
                    }
                    
                    do {
                        if let data = data {
                            let result = try JSONDecoder().decode(ResultModel.self, from: data)
                            if(result.status=="success"){
                                isLogin = true
                            }else {
                                isLogin = false
                                errorReason = result.reason
                            }
                        } else {
                            print("No data")
                        }
                    } catch let JsonError {
                        print("fetch json error:",JsonError.localizedDescription)
                    }
                }.resume()
            }label:{
                Text("LOGIN")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
            }
            Button{
                guard let url = URL(string:"http://:8081/postuser") else {
                    print("Not fund url")
                    return
                }
                
            let data = try! JSONSerialization.data(withJSONObject: ["user":username,"student_no":0,"user_stat":1 ,"passwd":passwd])
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = data
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                
                URLSession.shared.dataTask(with: request) { data, res, error in
                    if error != nil {
                        print("error",error?.localizedDescription ?? "")
                        return
                    }
                    do {
                        if let data = data {
                            let result = try JSONDecoder().decode(ResultModel.self, from: data)
                            DispatchQueue.main.async {
                                print(result)
                                if(result.status=="success"){
                                    print("ndjfgkahdwjakcnbf ivknjsb djkuwie")
                                    isLogin = true
                                } else {
                                    isLogin = false
                                    errorReason = result.reason
                                }
                            }
                        } else {
                            print("No data")
                        }
                    } catch let JsonError {
                        print("fetch json error:",JsonError.localizedDescription)
                    }
                }.resume()
            }label: {
                Text("REGISTER")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
            }
            Text(errorReason ?? "")
                .foregroundColor(.red)
                .font(.caption)
        }
    }
}

//struct loginView_Previews: PreviewProvider {
//    static var previews: some View {
//        loginView()
//    }
//}
