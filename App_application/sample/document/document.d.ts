
export interface TRow extends IArrayElement {
	Id: number;
	Qty: number;
	Price: number;
	Sum: number;
}

export interface TDocument extends IElement {
	Id: number;
	Date: Date;
	Done: boolean;
	No: number;
	Rows: IElementArray<TRow>;
	Sum: number
}
