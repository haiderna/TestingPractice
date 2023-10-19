//
//  CreateView.swift
//  TestingPractice
//
//  Created by NH on 9/15/23.
//

import SwiftUI

struct CreateView: View {
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    @StateObject private var vm = CreateViewModel()
    // focus state to remove attribute graph errors
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    firstName
                    lastName
                    job
                } footer: {
                    if case .validation(let err) = vm.error, let errorDesc = err.errorDescription {
                        Text("\(errorDesc)")
                            .foregroundColor(.red)
                    }
                }
                
                
                Section {
                   submit
                }
            }
            .disabled(vm.state == .submitting)
            .overlay {
                if vm.state == .submitting {
                    ProgressView()
                }
            }
            .navigationTitle("Create")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    done
                }
            }
            .onChange(of: vm.state) { formState in
                if formState == .successful {
                    dismiss()
                }
            }
            .alert(isPresented: $vm.hasError,
                   error: vm.error) {
    //            Button("Retry") {
    //                vm.fetchDetails(for: userId)
    //            }
            }
        }
        
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

private extension CreateView {
    var firstName: some View {
        TextField("First Name", text: $vm.person.firstName)
            .focused($focusedField, equals: .firstName)
    }
    
    var lastName: some View {
        TextField("Last Name", text: $vm.person.lastName)
            .focused($focusedField, equals: .lastName)
    }
    
    var job: some View {
        TextField("Job", text: $vm.person.job)
            .focused($focusedField, equals: .job)
    }
    
    var submit: some View {
        Button("Submit") {
            Task {
                await vm.create()
            }
        }
    }
    
    var done: some View {
        Button("Done") {
            focusedField = nil
            dismiss()
        }
    }
}

extension CreateView {
    enum Field: Hashable {
        case firstName
        case lastName
        case job
    }
}

// Post Request
// REST API -> post request -> rather than receive data, you send data and let it tell us if it was successful
// how to handle errors
// 
