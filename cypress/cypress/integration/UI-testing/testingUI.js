/// <reference types = "cypress" /> 

var baseUrl='https://www.globalsqa.com/samplepagetest/'

Cypress.on('uncaught:exception',(err, runnable)=>{
    return false;
    })


describe('UI testing',()=>{
    beforeEach(()=>{
    cy.visit(baseUrl)
    })

    it('Submit a user form with 3-5 years experience, two expertise and post graduate education',()=>{
        cy.fixture('dataUI.json').then(dataUI=>{
            cy.get('#g2599-name').type(dataUI.name)
            cy.get('#g2599-email').type(dataUI.email)
            cy.get('#g2599-experienceinyears').select('3-5')
            cy.get('[value="Functional Testing"]').check()
            cy.get('[value="Manual Testing"]').check()
            cy.get('[value="Post Graduate"]').check()
            cy.get('[name="g2599-comment"]').type(dataUI.comment)
        })
        cy.get('.pushbutton-wide').click()
        cy.contains('Expertise :: Functional Testing, Manual Testing').should('be.visible')
        cy.contains('Education: Post Graduate').should('be.visible')
    })

    it('Submit a user form with image',()=>{

        const fileName='small_img.jpg'
        cy.get('input[type=file]').attachFile(fileName)
        cy.fixture('dataUI.json').then(dataUI=>{
            cy.get('#g2599-name').type(dataUI.name)
            cy.get('#g2599-email').type(dataUI.email)
            cy.get('[name="g2599-comment"]').type(dataUI.comment)
        })
        cy.get('.pushbutton-wide').click()
        cy.contains('Name: User').should('be.visible')
    })

    it('Submit a user form with empty comment field', () => {
        cy.fixture('dataUI.json').then(dataUI=>{
            cy.get('#g2599-name').type(dataUI.name)
            cy.get('#g2599-email').type(dataUI.email)
        })
        cy.get('button[type="submit"]').click()
        cy.get('[name="g2599-comment"]').then(($input) => {
             expect($input[0].validationMessage).to.eq('Please fill out this field.')
            })
        })

describe('Alert Box testing',()=>{
    beforeEach(()=>{
        cy.visit(baseUrl)
    })

    it('Alert after click "OK" on confirming message',()=>{
        cy.get('[onclick="myFunction()"]').contains('Alert Box : Click Here').click()
 
        cy.on('window:confirm', (text) => {
            expect(text).to.contains('Do you really fill rest of the form?');
        });
        cy.on ('window:alert', (text)=>{
          expect(text).to.contain('Good Luck. Go for it')      
        })    
     })

     it('Alert after click "Cancel" on confirming message',()=>{
        cy.get('[onclick="myFunction()"]').contains('Alert Box : Click Here').click()
     
        cy.on('window:confirm', (text) => {
             expect(text).to.contains('Do you really fill rest of the form?');
            return false;
    
            });
    
         cy.on ('window:alert', (text)=>{
             expect(text).to.contain('Good Bye!!!')      
            })  
         })
    })
})



