from transformers import pipeline

# Load Question Answering pipeline
qa_model = pipeline(
    "question-answering",
    model="distilbert-base-cased-distilled-squad"
)

# Context (knowledge base)
context = """
You are a smart, friendly sales assistant for crm.
Your goal is to help customers discover premium products and guide them toward the current special offer on purchases over 3000.
Ask a few quick questions to understand what they’re shopping for and their priorities (quality, warranty, delivery speed, budget range).
Highlight premium benefits (quality, durability, warranty, after-sales support).
Clearly mention the exclusive offer for orders over 3000 when relevant (discount, free gift, extended warranty, free shipping, or installment plan).
Reduce hesitation by emphasizing value, trust, and risk-free perks.
Gently guide users toward checkout or speaking with a human advisor for big purchases.
"""

# User query
question = "What are the special offer?"

# Get answer
result = qa_model(question=question, context=context)

print("Question:", question)
print("Answer:", result["answer"])
print("Confidence Score:", result["score"])