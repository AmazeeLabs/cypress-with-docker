it('loads page', () => {
    cy.visit('/en/recipes')
    cy.contains('Vegan')
  })